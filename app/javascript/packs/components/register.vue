<template>
  <div class="card text-center">
    <div class="img-circle img-thumbnail img-responsive" id="div-login-logo">
      <i class="fa fa-4x fa-user-circle-o" aria-hidden="true" style="color: #707B85"></i>
    </div>
    <div class="card-block">
      <h4 class="card-title">注册</h4>
      <form id="div-form" :model="user">
        <div class="input-group">
          <span class="input-group-addon col-lg-2">&nbsp;&nbsp;<i class="fa fa-2x fa-user" aria-hidden="true"></i>&nbsp;&nbsp;</span>
          <input type="text" class="form-control" placeholder="用户名" v-model="user.name">
        </div>
        <div class="input-group">
          <span class="input-group-addon col-lg-2">&nbsp;<i class="fa fa-2x fa-envelope" aria-hidden="true"></i></span>
          <input type="email" class="form-control" placeholder="邮箱" v-model="user.email">
        </div>
        <div class="input-group">
          <span class="input-group-addon col-lg-2">&nbsp;&nbsp;<i class="fa fa-2x fa-unlock-alt" aria-hidden="true"></i>&nbsp;&nbsp;</span>
          <input type="password" class="form-control" id="input-password" placeholder="密码" v-model="user.password">
        </div>
      </form>
    </div>
    <div class="card-block">
      <a href="#" class="btn btn-primary" @click="register()">立即注册</a><br>
      <a href="#" class="card-link text-right">已经注册?</a>
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
      return {
        user: {
          name: '',
          email: '',
          password:''
        }
      }
    },
    methods: {
      register () {
          axios.post('http://localhost:3000/register', {
            user:this.user
          }).then(response => {
              console.log(response)
            // success callback
            }, response => {
            // error callback
            })
        }
    }
  }
</script>