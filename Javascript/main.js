//〇×のターンを分ける用のフラグ
let flag = true;
//カウンタのid
let counter_id = 0;
//盤面の状態を内部的に判別するための配列
const line = [
    0,0,0,
    0,0,0,
    0,0,0]
//オブジェクト化
const cell = document.querySelectorAll(".cell");
const count = document.getElementById("counter");
const start_btn = document.getElementById("btn");
const table = document.getElementById("table");
let time = 10;
for(let i=0; i < cell.length;i++){
    //セルが選択された時に色を変える
    cell[i].addEventListener("mouseover",() =>{
        for(let a=0;a<cell.length;a++){
            cell[a].classList.remove("selected");
            console.log("6");
        }
        cell[i].classList.add("selected");
        console.log("7"); 
    });

    start_btn.addEventListener("click",() =>{
        console.log("start_btn");
        table.classList.add("visible");
        count.textContent = " ";
        start_btn.classList.add("visible_none");
        timer();
    });

//選択されたセルに〇×を入力する
    cell[i].addEventListener("click",() => {
        cell[i].classList.add("effect");
        setTimeout(() =>{
            cell[i].classList.remove("effect");
        },100);
        if(line[i]===0){
            if(flag===true){
                cell[i].textContent = "〇";
                flag = false;
                line[i]=1;
                cell[i].classList.add("maru");
                console.log("1");
            }else{
                cell[i].textContent = "×";
                flag= true;
                line[i]=2;
                cell[i].classList.add("batu");
                console.log("2");
            }
            clearInterval(counter_id);
            timer();
            console.log("3");
            winChk();
        }
    });
}
//タイマー
const timer = () =>{
    console.log("timer");
    time = 10;
    counter_id = setInterval(() =>{
        time--;
        count.textContent = time;
        if(time <=0){
            console.log(`time ${time}`)
            count.textContent = 10;
            console.log(`timer id ${counter_id}`);
            autoHand(counter_id);
        }
    },1000);
}
//自動的に進行させる
const autoHand= id =>{
    console.log("autoHand_sta");
    clearInterval(id);
    console.log(`id ${id}`);
    do{
        random = Math.floor(Math.random() * line.length);
    }while (line[random] !== 0);
    cell[random].classList.add("effect");
    setTimeout(() =>{
        cell[random].classList.remove("effect");
    },100);
    if(flag===true){
        cell[random].textContent = "〇";
        flag = false;
        line[random]=1;
        cell[random].classList.add("maru");
    }else{
        cell[random].textContent = "×";
        flag= true;
        line[random]=2;
        cell[random].classList.add("batu");
    }
    timer();
    console.log("autoHand_end");
    winChk();
}


//勝利判定
const winChk = () =>{
    if((line[0]=== 1 && line[1]===1 && line[2] ===1) || (line[0]===2 && line[1]===2 && line[2]===2) ||
        (line[3]===1 && line[4]===1 && line[5]===1) || (line[3]===2 && line[4]===2 && line[5]===2) ||
        (line[6]===1 && line[7]===1 && line[8]===1) || (line[6]===2 && line[7]===2 && line[8]===2) ||
        (line[0]===1 && line[3]===1 && line[6]===1) || (line[0]===2 && line[3]===2 && line[6]===2) ||
        (line[1]===1 && line[4]===1 && line[7]===1) || (line[1]===2 && line[4]===2 && line[7]===2) ||
        (line[2]===1 && line[5]===1 && line[8]===1) || (line[2]===2 && line[5]===2 && line[8]===2) ||
        (line[0]===1 && line[4]===1 && line[8]===1) || (line[0]===2 && line[4]===2 && line[8]===2) ||
        (line[2]===1 && line[4]===1 && line[6]===1) || (line[2]===2 && line[4]===2 && line[6]===2)){
            winMsg();
        }
}
//判定結果の表示
const winMsg= () =>{
    console.log("5");
    if(flag===true){
        alert("×の勝ち"); 
    }else{
        alert("〇の勝ち");
    }
    const gameOver = confirm("END");
    if(gameOver == true){
        console.log("confirm true");
        window.location.reload();
    }
}
