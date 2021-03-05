#!/usr/bin/env groovy

def call(String name = 'human') {

    println("can you see this sayHello?")

    echo "Hello, ${name}."
}