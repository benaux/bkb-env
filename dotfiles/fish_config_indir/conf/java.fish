function set_j_path
   set java_vers $argv[1]

   if [ -f /usr/libexec/java_home ]
      /usr/libexec/java_home -v "$java_vers" 2>/dev/null
   end
end

# set JAVA_HOME and add to PATH
# if JAVA_HOME is changed in a session, it's going to be overwritten by this
if [ -z "$JAVA_HOME" ]  
   set jpath (set_j_path "$JAVA_VERS")

   if [ -d $jpath ] 
      set -gx JAVA_HOME $jpath
      set -gx PATH $JAVA_HOME/bin $PATH
   end
end
 
# Android stuff
set -gx ANDROID_HOME  $HOME/opt/android-sdk
set -gx ANDROID_SDK_ROOT $ANDROID_HOME

# Android SDK Tools
#    Location: $ANDROID_HOME/tools
#    Main tools: ant scripts (to build your APKs) and ddms (for debugging)
# Android SDK Platform-tools
#    Location: $ANDROID_HOME/platform-tools
#    Main tool: adb (to manage the state of an emulator or an Android device)
# Android SDK Build-tools
#     Location: $ANDROID_HOME/build-tools/$VERSION/
#     Main tools: aapt (to generate R.java and unaligned, unsigned APKs), dx (to convert Java bytecode to Dalvik bytecode), and zipalign (to optimize your APKs)


if [ -d $ANDROID_HOME ]
   for bindir in emulator tools/bin platform-tools build-tools/$ANDROID_BUILD_TOOLS_VERS
      if [  -d $ANDROID_HOME/$bindir ]
         set -gx PATH $ANDROID_HOME/$bindir $PATH
      end
   end
end

#set emulator_home $HOME/.android
#if  [ -d $emulator_home ]
   #set -gx ANDROID_EMULATOR_HOME $emulator_home
#end
