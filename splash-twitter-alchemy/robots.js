var Parse = require('parse/node');
var fs = require('fs');

Parse.initialize("6Eacg5VL8mAbhblIPc5gwOiRDds4fPKQeXaxA1QP", "NOBvTUFmbxpl1zTib1DTBU2zUtnQpJZQkVreH7lt");
var Ticket = Parse.Object.extend("Ticket");
var last_length = 0;

function job() {
  var content = fs.readFileSync('demo_splash.json', 'utf8')
  var data = JSON.parse(content);
  console.log("Retrieved data.");
  //console.log(data);
  var titles = data.map(function(item) {
    return item._id;
  });

  var changed = false;

  if (last_length != titles.length) {
    changed = true;
  }
  if (!changed) {
    console.log("Nothing has changed.");
    return;
  } else {
    console.log("Detected changes.");

    var ticketArray = [];

    for (var i = last_length; i < data.length; i ++) {
      var newTicket = new Ticket();
      newTicket.set("title", data[i]._id);
      newTicket.set(
        "description", data[i].tweets[0].content 
        + "   |   " 
        + data[i].tweets[1].content
      );
      newTicket.set("creator", "robot");
      newTicket.set("accepted", "N");
      newTicket.set("assigned", "N");
      newTicket.set("assignee", "N");
      newTicket.set("completed", "N");
      newTicket.set("priority", 2);
      console.log(newTicket.get("title"));
      console.log(newTicket.get("description"));
      ticketArray.push(newTicket);
    }


    Parse.Object.saveAll(ticketArray, {
      success: function(results) {
        console.log("Successfully saved changes");
      },
      error: function(obj, error) {
        console.log(error);
      }
    });
    last_length = titles.length;
  }
}

setInterval(job, 5000);
