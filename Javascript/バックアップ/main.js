let flag = true;
const line = [
    0,0,0,
    0,0,0,
    0,0,0]
const btn = document.querySelectorAll(".btn");
const cell = document.querySelectorAll(".cell");
for(let i=0; i < btn.length;i++){
    btn[i].addEventListener("click",() => {
        if(line[i]===0){
            if(flag===true){
                cell[i].textContent = "〇";
                flag = false;
                line[i]=1;
                console.log("1");
            }else{
                cell[i].textContent = "×";
                flag= true;
                line[i]=2;
                console.log("2");

            }
            console.log("3");
            win();            
        }
    })
}
const win = () =>{
    if((line[0]=== 1 && line[1]===1 && line[2] ===1) || (line[0]===2 && line[1]===2 && line[2]===2)){
        console.log("4");
        winMsg();
        }else if((line[3]===1 && line[4]===1 && line[5]===1) || (line[3]===2 && line[4]===2 && line[5]===2)){
            winMsg();
        }else if((line[6]===1 && line[7]===1 && line[8]===1) || (line[6]===2 && line[7]===2 && line[8]===2)){
            winMsg();
        }else if((line[0]===1 && line[3]===1 && line[6]===1) || (line[0]===2 && line[3]===2 && line[6]===2)){
            winMsg();
        }else if((line[1]===1 && line[4]===1 && line[7]===1) || (line[1]===2 && line[4]===2 && line[7]===2)){
            winMsg();
        }else if((line[2]===1 && line[5]===1 && line[8]===1) || (line[2]===2 && line[5]===2 && line[8]===2)){
            winMsg();
        }else if((line[0]===1 && line[4]===1 && line[8]===1) || (line[0]===2 && line[4]===2 && line[8]===2)){
            winMsg();
        }else if((line[2]===1 && line[4]===1 && line[6]===1) || (line[2]===2 && line[4]===2 && line[6]===2)){
            winMsg();
        }
}
const winMsg= () =>{
    console.log("5");
    if(flag===true){
        alert("×の勝ち"); 
    }else{
        alert("〇の勝ち");
    }
}