#!/bin/bash

#ps all processes and search for process keyword
psg() {
	ps aux | grep $1
}
