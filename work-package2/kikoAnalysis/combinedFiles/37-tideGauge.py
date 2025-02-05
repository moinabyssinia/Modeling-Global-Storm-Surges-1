# -*- coding: utf-8 -*-
"""
Created on Tue Apr 16 16:11:00 2020
--------------------------------------------
Load predictors for each TG and combine them
--------------------------------------------

@author: Michael Tadesse
"""

import os 
import pandas as pd

#define directories
dir_in = '/lustre/fs0/home/mtadesse/eraFiveConcat'
dir_out = '/lustre/fs0/home/mtadesse/ereaFiveCombine'

def combine():
    
    os.chdir(dir_in)
    
    #get names
    tg_list_name = os.listdir()
    
    #cd to where the actual file is 
    os.chdir(dir_in)
    
    x = 37
    y = 38 
    
    for t in range(x, y):
        tg_name = tg_list_name[t]
        print(tg_name, '\n')
        
        
        #looping through each TG folder
        os.chdir(tg_name)
        
        #defining the path for each predictor
        where = os.getcwd()
        
    
        csv_path = {'slp' : os.path.join(where, 'slpDaily.csv'),\
                    'wnd' : os.path.join(where, 'wndDaily.csv')}
        
     
        
        first = True   
        for pr in csv_path.keys():
            print(tg_name, ' ', pr)
              
            #read predictor
            pred = pd.read_csv(csv_path[pr])
            
            #remove unwanted columns
            pred.drop(['Unnamed: 0'], axis = 1, inplace=True)
            
            #place date column to the first column
            firstCol = pred.pop('date')
            pred.insert(0, 'date', firstCol)
            
            #give predictor columns a name
            pred_col = list(pred.columns)
            for pp in range(len(pred_col)):
                if pred_col[pp] == 'date':
                    continue
                pred_col[pp] = pr + str(pred_col[pp])
            pred.columns = pred_col
            
            #merge all predictors
            if first:
                pred_combined = pred
                first = False
            else:
                pred_combined = pd.merge(pred_combined, pred, on = 'date')
            
        #saving pred_combined
        os.chdir(dir_out)
        pred_combined.to_csv('.'.join([tg_name, 'csv']))
        os.chdir(dir_in)
        print('\n')


#run script
combine()



