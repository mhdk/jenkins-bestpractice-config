#!/usr/bin/env groovy

// Note we have changed from echo to writeline statements for writing to a file.

import groovy.io.FileType;
import java.io.File;
import java.util.Calendar.*;
import java.text.SimpleDateFormat
import hudson.model.*

// @NonCPS
def call() //Map config=[:]
{
    def dir = new File(pwd());

    println("can you see this simplenotes?")

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

        // Getting the date and time with simple code and echoing it to the console.
        def now = new Date();
        def fmt = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
        writer.writeLine("Date and Time IS: " + fmt.format(now));

        // "currentBuild.getBuildNumber()" doesn't get us the current build number
        // but rather the last one.
        // Here we just let Jenkins interpolate the build number environment
        // variable here.
        writer.writeLine("Build Number is: ${BUILD_NUMBER}");

        // Getting the change-sets associated with our current build.
        def changeLogSets = currentBuild.changeSets;

        // assume not everyone wants our new features - all that some of our pipeline
        // builds are going to do is generate documentation. So, we wan't a file list but
        // not the SCM details.
        if (config.changes != "false")
        {
            // We are looping through each change set in the collection,
            for (change in changeLogSets)
            {

                // and getting the entries for each change-set.
                def entries = change.items;

                // Then we are looping through each item in the entry.
                for (entry in entries)
                {
                    // we are writing out the comit ID, author, timestamp and commit message.
                    writer.writeLine("${entry.commitId} by ${entry.author} on ${new Date(entry.timestamp)}: ${entry.msg}");

                    // Finally we are writing out the affected files.
                    for (file in entry.affectedFiles)
                    {
                        writer.writeLine("${file.editType.name} ${file.path}");
                    }
                }
            }
        }
    }
}
