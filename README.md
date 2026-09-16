Instructions for Gd Extension

Official Documentation: https://docs.godotengine.org/en/4.6/tutorials/scripting/cpp/gdextension_cpp_example.html

 Build Gdextension:
   1. open terminal
   2. cd to local repo
   3. run: scons

        - Optionally to create linux binaries run: scons platform=Linux


Instructions for Creating Tests

 1. Create a folder in the Test directory with the name of your test
 2. Create a scene in your new test directory
 3. Attach a script to your scene
 4. Modify the script to extend from IScenario
 5. Override the run function with the code for your test and return true or false for passing and failng
 6. Repeat steps 2-5 for as many scenarios as you need for your test
 7. Add the test directory to the list of directories in the TestAll scene through the inspector
 8. Run the TestAll scene to run all tests. To specify a single test to run check off "Run Single Test" and specify the test directory
