# MiniLib Documentation

A modern, animated UI library for Roblox, designed to create customizable windows with sections and interactive elements like buttons, toggles, labels, and keybinds. The library uses Roblox's TweenService for smooth animations and UserInputService for draggable windows and input handling.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Functions](#functions)
  - [Library:NewWindow(title)](#librarynewwindowtitle)
  - [Window:NewSection(sectionTitle)](#windownewsectionsectiontitle)
  - [Section:CreateButton(buttonText, callback)](#sectioncreatebuttonbuttontext-callback)
  - [Section:CreateToggle(toggleText, defaultState, callback)](#sectioncreatetoggletoggletext-defaultstate-callback)
  - [Section:CreateLabel(labelText)](#sectioncreatelabellabeltext)
  - [Section:CreateKeybind(keybindText, defaultKey, callback)](#sectioncreatekeybindkeybindtext-defaultkey-callback)
- [Examples](#examples)
- [Notes](#notes)

## Overview

ReplicateSignalUI provides a sleek, modern interface for creating menus in Roblox. The UI is fully draggable, responsive, and includes smooth tween animations for opening/closing the window, hovering effects, and toggles.

## Installation

To use the library, simply require the script:

```lua
local Library = loadstring(game:HttpGet(""))()
