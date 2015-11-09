import threading
import eventsentiment
import time

while True:
	threading.Timer(5.0, eventsentiment.main, ["#cornelltech", 20]).start()
	time.sleep(5.0)
	