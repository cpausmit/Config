from bs4 import BeautifulSoup

with open('/home/submit/paus/cms/data/nanoao/523/Charmonium+Run2018D-UL2018_MiniAODv2-v1+MINIAOD/AE443B55-286F-A341-B51C-98A8C5C41A08.empty') as f:
    data = f.read()

bs_data = BeautifulSoup(data,"xml")
b_unique = bs_data.find_all('PerformanceReport')
print(b_unique)

b_name = bs_data.find('Metric', {'Name':'Timing-tstoragefile-readPrefetchToCache-totalMsecs'})
print(b_name)

value = b_name.get('Value')
print(f" Value: {value}")
