#!/usr/bin/python
import socket,os,sys,time
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(("143.248.198.103", 5005))

fname = sys.argv[1]
client_socket.send(fname)
client_socket.close()
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(("143.248.198.103", 5005))

with open(fname,'rb') as infile:
    while True:
        strng = infile.readline(512)
        if not strng:
            break
        client_socket.send(strng)
client_socket.close()
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(("143.248.198.103", 5005))
response = client_socket.recv(1024)
client_socket.close()
print response

