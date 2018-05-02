'use strict';

const fs = require('fs');

var rawdata = fs.readFileSync('accounts.json');  
var student = JSON.parse(rawdata);  

/*let json=require('accounts.json');
console.log(json);  
*/
var adminController = {
    
stopGame: function(req, res){

	var arr = ['RED','BLACK'];
    var winner = arr[Math.floor(Math.random() * arr.length)]; 
    res.send(winner);
}
,
startGame: function(req,res){
	res.send("Yes");

},
 getKey: function(req,res){
	var people = [];
	var x=req.query.key;
	console.log("in get key");
/*
 	for(var exKey in student) {
 		if(exKey===x)
 			res.send(student[exKey]);
    console.log("Name:"+exKey);
	}*/
   /*var privateKey = student.x;
   	res.send(student.x);
    console.log(privateKey);
*/
res.send(student[x]);
 },

selectPlayers: function(req,res){
	var arr = ['Rohan Acharya',	'Nikhil Agrawal','FNU APRAJITA','Tarun Arora','Gaurav Bajaj',
'Pratik Baniya','William Baron','Kirati Bhuva',	'Shraddha Chadha', 'Tholkappian Chidambaram',	
'Nrupa Chitley','Rachit Chokshi',	
'Aditya Chouhan',	
'Anna Chow',	
'Kevin Chuang',	
'Bruce Decker',	
'Heli Dipakkumar Desai',	
'Venkatesh Devale'	,
'Tarang Dhulkotia'	,
'Jyothsna Goalla Dilli Naidu',	
'Venkat Pushpak Gollamudi',	
'Animesh Grover',	
'Sheethal Halandur Nagaraja',	
'Huy Huynh'	,
'Kashika Jain',	
'Shraddha Jamadade',	
'Kaustubh Jawalekar',
'Shraddha Kabade',
'Vajid Kagdi',
'Deekshitha Reddy Kankanala',
'Zainab Khan',
'Vishwajeet Kharote',
'Varun Khatri',
'Raviteja Kommalapati',
'LakshmiPrasanna Kona',
'Effendy Kumala',
'Mitesh Kumar',
'Sunil Lalwani',
'Chunchen Lin',
'Haoji Liu',
'Chikei Loi',
'Savitri Swapna Maddula',
'Watcharit Maharutainont',
'Murtaza Manasawala',
'Sasank Matavalam',
'Megha Nair',
'Suhas Nayak',
'Thien Nguyen',
'Vu Nguyen',
'Spandana Padala',
'Tejal Laxmidas Padharia',
'MITTRANJ PANSURIYA',
'Zenobia Adnan Panvelwala',
'Jaykumar Patel',
'Pradnyesh Patil',
'Sneha Patil',
'Vishwanath Patil',
'Emma Peatfield',
'Sayali Pisal',
'Manikant Prasad',
'Faisal Rahman',
'Pranjali Sanjay Raje',
'Roopam Rajvanshi',
'Charu Ramnani',
'Rakesh Ranjan',
'Harshrajsinh Vijaysinh Rathod',
'Sricheta Ruj',
'PREMAL DATTATRAY SAMALE',
'Mahitee Satasiya',
'Aishwarya Saxena',
'Akshat Alpesh Shah',
'Shreya Shah',
'Abhin Sharma',
'Rohit Sharma',
'Manisha Shivshette',
'Abhishek Singh',
'Sravya Somisetty',
'Deepti Srinivasan',
'Srinivasa Prasad Sunnapu',
'Vineet Tyagi',
'Viraj Upadhyay',
'Vignesh Venkateswaran',
'Vidhya Vijayakumar',
'Vera Wang',	
'Tong Wu',
'Mario Yepez',
'Matthew Zhu'];

    var players = arr[Math.floor(Math.random() * arr.length)]; 
    res.send(players);

}

};
 
module.exports = adminController;





