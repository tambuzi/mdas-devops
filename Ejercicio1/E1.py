#!/usr/bin/env python
#enconding: utf-8

import requests 
import time
import json


def retry():
    for n in range(1, 4):
        print ("try " + str(n))
        test = getData()
        t = 3
        if test.status_code == 200:
            print ("Connection success")
            winner = json.loads(test.text)
            #return winner['winner']
            print ("Winner is " + winner['winner'])
            expectedWinner="Dev"
            if expectedWinner == winner['winner']:
                print ("TEST PASSED")
                return 1
            else:
                print ("TEST FAILED")
                return 0
        else:
            print ("Connection lost")
            time.sleep(t)


# test
def getData():
    votingurl='http://localhost:80/vote'
    
    requests.post(votingurl, data='{"topics":["Dev","Ops"]}', headers={"Content-Type":"application/json"})
    requests.put(votingurl, data='{"topic":"Dev"}',  headers={"Content-Type":"application/json"})
    winner = requests.delete(votingurl,  headers={"Content-Type":"application/json"})
    return winner
    
    
if __name__ == "__main__":
    time.sleep(5) # Relentizamos el inicio del test para que Go se ejecute antes
    retry() 