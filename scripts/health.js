
var currentWakeUpTimer = null;

STATUS_IDLE = 0;
STATUS_GDNT = 1;
STATUS_WAKE = 2;

tmpVolunteer = STATUS_IDLE;

function wakeMeUpTom(msg) {
	if (currentWakeUpTimer != null) {
		msg.send("I already have an alarm set to wake you up.");
		return;
	}

	currentWakeUpTimer = {};

	currentWakeUpTimer.func = function() {
		member = "#chatname";
		currentWakeUpTimer = null;
		// msg.send((new Date(currentWakeUpTimer.ctime)).toString());
		msg.send(["Wake up!", member,"\n"].join(" "));
		tmpVolunteer = STATUS_WAKE;
	}

	HOURS_24 =  24 * 60 * 60 * 1000;
	HOURS_24 =  3 * 1000;
	now = new Date();
	currentWakeUpTimer.ctime = now.getTime() + HOURS_24;


	tmpD = new Date(currentWakeUpTimer.ctime);		
	// tmpD.setHours(7);
	// tmpD.setMinutes(0);
	// tmpD.setSeconds(0);
	msg.send("The time right now is " + now.toString());
	msg.send("And I will wake you up by " + tmpD.toString());

	currentWakeUpTimer.ctime = tmpD.getTime();
	currentWakeUpTimer.length = currentWakeUpTimer.ctime - now.getTime();
	msg.send("#### Due to time limitation, you're only allowed to sleep for " + (currentWakeUpTimer.length/1000) + " seconds. ####");

	currentWakeUpTimer.timer = setTimeout(currentWakeUpTimer.func, currentWakeUpTimer.length);		
}

module.exports = function(robot) {
	member = "#chatname";

	robot.brain.data.pomodoros = (robot.brain.data.pomodoros || 0);

	robot.hear(/yawn/i, function(msg) {
		if (tmpVolunteer == STATUS_WAKE) {
			msg.send("Good morning, " + member + ".");
			msg.send("For breakfast, yogurt is available. How about a cup of coffee?");
			tmpVolunteer = STATUS_IDLE;
		}

	});

	robot.hear(/coffee/i, function(msg) {
		msg.send("There should still be some coffee beans left.");
		msg.send("Before you grind the beans, don't forget to use the following ratio for your brew:");
		msg.send("-- use 300g of hot water for every 20g of coffee beans.");
	});

	robot.hear(/yes/i, function(msg) {
		if (tmpVolunteer == STATUS_GDNT) {
			wakeMeUpTom(msg);
			msg.send("Have a good night sleep!");
		}
		tmpVolunteer = STATUS_IDLE;
	});

	robot.hear(/no/i, function(msg) {
		if (tmpVolunteer == STATUS_GDNT) {
			msg.send("Okay. Have a good night sleep, " + member + ".");
		}
		tmpVolunteer = STATUS_IDLE;
	});

	robot.hear(/good night(.*)/i, function(msg) {
	    if (currentWakeUpTimer == null) {
			msg.send("Do you want me to wake you up tomorrow, " + member + "?");
			tmpVolunteer = STATUS_GDNT;
		} else {
			msg.send("Okay. Have a good night sleep, " + member + ".");
		}
	});

	robot.hear(/wake/i, function(msg) {
		wakeMeUpTom(msg);
	});
}
