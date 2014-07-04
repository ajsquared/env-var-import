# env-var-import

## Introduction

On OS X, a GUI Emacs instance will have a different environment from
one started in the shell.  This library works around that by copying
environment variables from the shell.

## Installation 

1. Place env-var-import.el somewhere on your Emacs load path.
2. Add ```(require 'env-var-import)``` to your .emacs

env-var-import.el is also available in Marmalade.  If you are using
Emacs 24 or have package.el set up, simply run ```M-x package-install
env-var-import``` to install.  See the
[Marmalade page](http://marmalade-repo.org/) for setup instructions.

## Usage

To use env-var-import, call ```env-var-import``` in your Emacs
configuration.

It can be called like ```(env-var-import)```.  In this mode, it will
only import the value of the environment variable defined in
```env-var-import-exec-path-var``` and set ```exec-path``` to that
value.  ```env-var-import-exec-path-var``` defaults to ```PATH``` but
is customizable.

It can also be called like ```(env-var-import '("VAR1", "VAR2"))```.
In this mode it will still import the value of the environment
variable defined in ```env-var-import-exec-path-var``` and set
```exec-path``` to that value.  However, it will also import the
values of ```VAR1``` and ```VAR2```.
