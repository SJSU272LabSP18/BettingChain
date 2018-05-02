
var adminController = {


stopGame: function(req,res){

	var arr = ['RED','BLACK'];
    var winner = arr[Math.floor(Math.random() * arr.length)]; 
    res.send(winner);

}
};
 
module.exports = adminController;





