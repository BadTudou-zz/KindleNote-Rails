<template>
  <div class="text-center">
    <div class="img-circle img-thumbnail img-responsive" id="div-login-logo">
      <i class="fa fa-4x fa-rocket" aria-hidden="true"></i>
    </div>
    <div class="card-block">
      <h4 class="card-title">登陆</h4>
      <form id="div-form" :model="user" :rules="rules">
        <div class="input-group">
          <span class="input-group-addon" id="basic-addon1"><i class="fa fa-1x fa-user" aria-hidden="true"></i></span>
          <input type="text" class="form-control" id="input-name" placeholder="用户名" v-model="user.name">
        </div>
        <div class="input-group">
          <span class="input-group-addon" id="basic-addon1"><i class="fa fa-1x fa-lock" aria-hidden="true"></i></span>
          <input type="password" class="form-control" id="input-password" placeholder="密码" v-model="user.pass">
        </div>
      </form>
    </div>
    <div class="card-block">
      <a href="#" class="btn btn-primary" @click="submitForm('user')">立即登陆</a><br>
      <a href="#" class="card-link text-right">忘记密码?</a>
    </div>
  </div>
</template>

<style type="text/css">
#div-login-logo
{
  color: #0099F0; width: 90px; height: 90px; margin-top: 5px; padding-top: 10px;
}
#div-form, .input-group
{
  margin-top: 15px;
}
</style>
</template>

<script>
export default {
    data () {
      var validateName = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请输入用户名'))
        } else {
          callback()
        }
      }
      var validatePass = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请输入密码'))
        } else {
          callback()
        }
      }
      return {
        user: {
          name: '',
          pass: '',
        },
        rules: {
          name: [
            { validator: validateName, trigger: 'blur' }
          ],
          pass: [
            { validator: validatePass, trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      submitForm (formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http.get('http://admin.dev.weipeiapp.com').then(response => {
              console.log(response)
            // success callback
            }, response => {
            // error callback
            })
          } else {
            console.log('error submit!!')
            return false
          }
        })
      },
      resetForm (formName) {
        this.$refs[formName].resetFields()
      }
    }
  }
</script>