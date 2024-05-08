#!/bin/bash

main() {
updating
}

updating() {
yum clean all
yum update -y
shutdown -r now
}
