#!/usr/bin/env groovy

// Note we have changed from echo to writeline statements for writing to a file.

import groovy.io.*;
import java.io.*;

// @NonCPS
def call() //Map config=[:]
{
    def dir = new File(pwd());

    new File(dir.path + '/releasenotes.txt').withWriter('utf-8')
    {
        writer ->
            // list of file names and sizes (for files, no sizes for directories).
            dir.eachFileRecurse(FileType.ANY){ file ->
                if (file.isDirectory())
                {
                    writer.writeLine(file.name);
                }
                else
                {
                    writer.writeLine('\t' + file.name + '\t' + file.length());
                }
            }
    }
}
