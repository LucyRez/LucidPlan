var mongoose = require("mongoose");
var Schema = mongoose.Schema;

var enemy = new Schema({
    imageName: String,
    health: Number,
    maxHealth: Number,
    damage: Number
});

const Enemy = mongoose.model("Enemy", enemy);
module.exports = Enemy