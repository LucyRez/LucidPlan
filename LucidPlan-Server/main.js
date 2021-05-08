const express = require("express")();
const cors = require("cors"); // Allows communication with server from different port.
const http = require("http").createServer(express);
const io = require("socket.io")(http);

var Game = require("./gameSchema");
var Enemy = require("./enemySchema");
var User = require("./userSchema");

const {MongoClient} = require("mongodb");
const client = new MongoClient("mongodb://localhost:27017/mydb", {native_parser: true});

express.use(cors());

var collection;

io.on("connection", (socket) =>{

    socket.on("test", (mes) =>{
        console.log(mes);
    });

    socket.on("join", async (groupId) => {
        try{
            let result = await collection.findOne({"_id" : groupId});
            console.log("Trying to join");
            if(!result){
               // await collection.insertOne({"_id": groupId, messages:[]});
               console.log("Failed to join");
               socket.emit("joined", ""); // Return something else 'cause room doesn't exist.
            }else{
                socket.join(groupId);
                socket.emit("joined", groupId); 
                socket.activeRoom = groupId;
                console.log("Joined");
            }
           
        }catch(e){
            console.error(e);
        }
       
    });

    socket.on("createRoom", async (groupId) => {
        try{
            let result = await collection.findOne({"_id" : groupId});
            console.log("Trying to create room")
            // If room with this id doesn't exist
            if(!result){
                await collection.insertOne({"_id": groupId, messages:[]});
                socket.join(groupId);
                socket.emit("roomCreated", groupId); 
                socket.activeRoom = groupId;
                console.log("Room was created");

                var enemy = new Enemy({
                    imageName: String,
                    health: Number,
                    maxHealth: Number,
                    damage: Number
                })

                var user = new User

                var game = new Game({


                });
            }else{
                socket.emit("roomCreated", ""); // Return something else if room allready exists
                console.log("Room wasn't created")
            }
            
        }catch(e){
            console.error(e);
        }
    });

    socket.on("message", (message) =>{ 
        collection.updateOne({"_id": socket.activeRoom}, {
            "$push": {
                "messages": message
            }
        });
        io.to(socket.activeRoom).emit("message", message);
    }); 

});

express.get("/messages", async (request, response) => {
    try{
        let result = await collection.findOne({"_id": request.query.room}); 
        response.send(result);
    }catch(e){
        response.status(500).send({message : e.message});
    }
});

http.listen(3000, async () => {
    try{
        await client.connect();
        collection = client.db("lucidPlan").collection("groups"); 
        console.log("Listening on port: %s", http.address().port);
    }catch(e){
        console.error(e);
    }
});