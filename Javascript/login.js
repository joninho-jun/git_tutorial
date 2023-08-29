const number = document.querySelectorAll(".number");
const number_array = [0,0,0];
const password = ["","",""]
const plus_btn = document.querySelectorAll(".plus_btn");
const minus_btn = document.querySelectorAll(".minus_btn");
const reset_btn = document.getElementById("reset");
const login_btn = document.getElementById("login");
for(let i =0;i<number.length;i++){
    plus_btn[i].addEventListener("click",()=>{
        if(number_array[i]===9){
            number_array[i]=0;
        }else{
            number_array[i]++;
        }
        number[i].textContent=number_array[i];
        password[i]=password[i] + "P";
        console.log(password[i]);
    });
    minus_btn[i].addEventListener("click",()=>{
        if(number_array[i]===0){
            number_array[i]=9;
        }else{
            number_array[i]--;
        }
        number[i].textContent=number_array[i];
        password[i]=password[i] + "M";
        console.log(password[i]);
    });
}
reset_btn.addEventListener("click",()=>{
    for(let i=0;i<password.length;i++){
        password[i] = "";
        number_array[i] =0;
        number[i].textContent = number_array[i];
    }
});
login_btn.addEventListener("click",()=>{
    auth_word=[
        "PMM",
        "PMM",
        "PMM"
    ];
    if(auth_word[0]===password[0] && auth_word[1]===password[1] && auth_word[2]===password[2]){
        location.href="index.html";
    }else{
        alert("暗証番号が違います");
    }
}); 