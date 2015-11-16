import threading
import eventsentiment
import time
import os, sys

def sprint_demo(search_term):
	eventsentiment.main(search_term, 100)
	while True:
		threading.Timer(20.0, eventsentiment.main, [search_term, 10]).start()
		time.sleep(10.0)
	
if __name__ == "__main__":
    sprint_demo(sys.argv[1])