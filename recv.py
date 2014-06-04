import socket, qrcode, os,time


def dec(file):
    d = qrcode.Decoder()
    d.decode(file)
    return d.result

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind(("", 5005))
server_socket.listen(10)


while True:
    
    client_socket, address = server_socket.accept()
    print address
    fname = client_socket.recv(1024)
    client_socket.close()
    client_socket, address = server_socket.accept()
    print fname

    with open(fname,'wb') as infile:
        while True:
            strng = client_socket.recv(512)
            if not strng:
                break
            infile.write(strng)
    client_socket.close()
    #decoding the QR received
    t = dec(fname)
    #Establishing another socket communication
    client_socket, address = server_socket.accept()
    client_socket.send(t)
    client_socket.close()
#    server_socket.close()#143.248.141.81

    print t
    time.sleep(5)