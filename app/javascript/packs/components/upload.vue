<template>
  <div id='upload'>
    <el-upload
      class="upload-demo"
      drag
      action="./"
      :on-success="onSuccess"
      multiple>
        <i class="el-icon-upload"></i>
        <!-- 后台无法接收到token -->
        <!-- <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>"> -->
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip text-center" slot="tip">支持Kindle Clipping.txt，2MB以下</div>
    </el-upload>
  </div>
</template>

<script>
  export default {
    data: function () {
      return {
      }
    },
    methods: {
      onSuccess: function (response, file, fileList){
          console.log(response);
          let data = response;
            if (data.status){
              console.log(data.message)
              window.location.href = data.url
            } else{
              location.reload()
            }
      }
    }
  }
</script>