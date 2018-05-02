var adminController = {

stopGame: function(req,res){

	var arr = ['red','black'];
    var winner = arr[Math.floor(Math.random() * arr.length)]; 
    res.send(winner);

}
};
 
module.exports = adminController;





