var app = new Vue({
    el: '#login',
    data: {
      user:{
        name:'',
        email:'',
        password:''
      }
    },
    methods: {
      login () {
          axios.post('/login',{
            user:this.user
          }).then(response => {
            console.log(response)
            let data = response.data
            if (data.status){
              window.location.href = data.url
            } else{
              location.reload()
            }
            // success callback
          }, response => {
            // error callback
          })
      }
    }
})