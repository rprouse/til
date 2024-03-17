# ADB Error Logs

I have an Android application that only happens with Release builds, so I cannot
debug the issue. To get information about the error, I am using `adb` to get logs
from the device while the application is running.

I start with `adb devices` to ensure that the phone is connected for debugging.
I then get the application to the point of failure. Android produces many logs, so
I want to start tailing the logs as close to the point of failure as possible and
I want to filter the logs down to just error logs.

To filter the logs, I use `adb logcat *:E` which just shows error logs. Then I
hit the error in my app and immediately `Ctrl+C` to stop tailing the logs. The error
should be some of the most recent. There may be many, but hopefully you can get the
PID of your process and further filter from there. For example, I found this error
line for my app,

```txt
03-17 17:43:18.691  4113  4113 E AndroidRuntime: Process: net.alteridem.hamradiostudy, PID: 4113
```

This allowed me to ignore the other errors and just look at the exception in my
application,

```txt
03-17 17:43:18.691  4113  4113 E AndroidRuntime: FATAL EXCEPTION: main
03-17 17:43:18.691  4113  4113 E AndroidRuntime: Process: net.alteridem.hamradiostudy, PID: 4113
03-17 17:43:18.691  4113  4113 E AndroidRuntime: android.runtime.JavaProxyThrowable: [System.Reflection.TargetInvocationException]: Arg_TargetInvocationException
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Reflection.MethodBaseInvoker.InvokeDirectByRefWithFewArgs(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Reflection.MethodBaseInvoker.InvokeWithOneArg(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Reflection.RuntimeConstructorInfo.Invoke(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.RuntimeType.CreateInstanceImpl(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Activator.CreateInstance(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Activator.CreateInstance(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at HamRadioStudy.Services.NavigationService+<NavigateToAsync>d__0.MoveNext(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Runtime.CompilerServices.TaskAwaiter.ThrowForNonSuccess(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at HamRadioStudy.ViewModels.MainPageViewModel+<<get_TakeQuizCommand>b__13_0>d.MoveNext(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at System.Threading.Tasks.Task+<>c.<ThrowAsync>b__128_0(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at Android.App.SyncContext+<>c__DisplayClass2_0.<Post>b__0(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at Java.Lang.Thread+RunnableImplementor.Run(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at Java.Lang.IRunnableInvoker.n_Run(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at Android.Runtime.JNINativeWrapper.Wrap_JniMarshal_PP_V(Unknown Source:0)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at mono.java.lang.RunnableImplementor.n_run(Native Method)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at mono.java.lang.RunnableImplementor.run(RunnableImplementor.java:31)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at android.os.Handler.handleCallback(Handler.java:958)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at android.os.Handler.dispatchMessage(Handler.java:99)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at android.os.Looper.loopOnce(Looper.java:205)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at android.os.Looper.loop(Looper.java:294)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at android.app.ActivityThread.main(ActivityThread.java:8177)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at java.lang.reflect.Method.invoke(Native Method)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:552)
03-17 17:43:18.691  4113  4113 E AndroidRuntime:        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:971)
```
