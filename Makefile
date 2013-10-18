## NanoRPC
CC = g++
CCFLAGS = -ansi -Wall -Wno-deprecated -O2 -DNDEBUG
CCFLAGS += -I/opt/local/include
CCFLAGS += -I/usr/local/include
LDFLAGS = -rdynamic
LDFLAGS += -L/opt/local/lib
LDFLAGS += -L/usr/local/lib

PROTOC = protoc
MKDIR  = mkdir -p

PROTO_LDFLAGS = -lprotobuf
NANOMSG_LDFLAGS = -lnanomsg
CITYHASH_LDFLAGS = -lcityhash

USE_LDFLAGS = $(PROTO_LDFLAGS) $(CITYHASH_LDFLAGS) $(NANOMSG_LDFLAGS) 

TMPLIB = .libs

SOURCES = \
	$(TMPLIB)/Server.o \
	$(TMPLIB)/Channel.o \
	$(TMPLIB)/echo.pb.o


all:	mkdir echo_client echo_server

mkdir:
	$(MKDIR) $(TMPLIB)

echo_client:	$(SOURCES) $(TMPLIB)/EchoClient.o
	$(CC) $(CCFLAGS) $(LDFLAGS) $(USE_LDFLAGS) -o echo_client $(SOURCES) $(TMPLIB)/EchoClient.o

echo_server:	$(SOURCES) $(TMPLIB)/EchoServer.o
	$(CC) $(CCFLAGS) $(LDFLAGS) $(USE_LDFLAGS) -o echo_server $(SOURCES) $(TMPLIB)/EchoServer.o

$(TMPLIB)/Channel.o:	Channel.cc Channel.hh
	$(CC) -c $(CCFLAGS) Channel.cc -o  $(TMPLIB)/Channel.o

$(TMPLIB)/Server.o:	Server.cc Server.hh
	$(CC) -c $(CCFLAGS) Server.cc -o  $(TMPLIB)/Server.o

$(TMPLIB)/EchoClient.o:	EchoClient.cc EchoCommon.hh
	$(CC) -c $(CCFLAGS) EchoClient.cc -o  $(TMPLIB)/EchoClient.o

$(TMPLIB)/EchoServer.o:	EchoServer.cc EchoCommon.hh
	$(CC) -c $(CCFLAGS) EchoServer.cc -o  $(TMPLIB)/EchoServer.o

$(TMPLIB)/echo.pb.o:	echo.pb.cc echo.pb.h
	$(CC) -c $(CCFLAGS) echo.pb.cc -o  $(TMPLIB)/echo.pb.o

echo.pb.cc echo.pb.h: echo.proto
	$(PROTOC) --cpp_out=. echo.proto

clean:
	rm -f EchoClient EchoServer $(TMPLIB)/*.o