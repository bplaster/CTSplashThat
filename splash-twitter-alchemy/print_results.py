import os, sys, string, time, re
import requests, json, urllib, urllib2, base64
import pymongo
from multiprocessing import Pool, Lock, Queue, Manager
import collections
import subprocess

def print_results():
    
    db = pymongo.MongoClient().twitter_db
    tweets = db.tweets_sprintdemo

    neg_tweets = tweets.find({"sentiment" : {"$lt" : 0}})

    for doc in neg_tweets:
        print doc["text"]

    most_neg_tweets = tweets.aggregate([    
        {"$unwind" : "$keyword"},
        {"$match": {"sentiment": {"$lt":0}}},
        {"$group": {"_id": "$keyword", "count": {"$sum":1}, "avgScore": {"$avg": "$sentiment"}, "tweets":{"$push": {"content": "$text", "sentiment":"$sentiment"}}}},
        {"$sort": {"count": -1, "avgScore":-1, "tweets.sentiment": -1}}, #sorting by tweets.sentiment not working
        {"$match": {"count": {"$gt":1}}}, #threshold = 1 now
        {"$out": "most_neg_tweets_sprintdemo"}
        ])

    subprocess.call("mongoexport --db twitter_db --collection most_neg_tweets_sprintdemo --fields 'tweets.content' --out sprint_demo.json --jsonArray", shell=True)

    return

if __name__ == "__main__":

    print_results()