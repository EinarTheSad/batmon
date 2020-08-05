#include "fbgfx.bi"
using fb

var resx = 800
var resy = 480
var percentage = 100
var status = ""
var message_shown = 0
dim cells as integer = 4
const red = 12
const yellow = 14
const orange = 42
const green = 2

'cell drawing subprogram
sub celldraw(i as integer)
	var cellx = 6
	var j = 1
	var c = 0
	if i > 2 then
		c = green
	end if
	if i = 2 then
		c = orange
	end if
	if i < 2 then
		c = red
	end if
	for j = 1 to i
		Line (cellx, 6)-(cellx + 3, 13), c, BF
		cellx = cellx + 5
	next j
end sub

'lightning drawing sub
sub charge(col as integer)
	var i = 1
	var x = 14
	var y = 8
	for i = 1 to 3
		Line (x,y)-(x+1,y), col
		Line (x,y+5)-(x+1,y+5), col
		x = x + 1
		y = y - 1
	next i
	Line (13,9)-(19,9), col
	Line (12,10)-(18,10), col
end sub

ScreenControl GET_DESKTOP_SIZE, resx, resy
ScreenRes 33, 20, 8, , (GFX_SHAPED_WINDOW or GFX_ALWAYS_ON_TOP)

ScreenControl SET_WINDOW_POS, resx-33, 0
Palette 16, &h00000000
Paint(0,0),16

'battery shape
Line (5,4)-(25,4), 15
Line (5,15)-(25,15), 15
Line (4,5)-(4,14), 15
Line (26,5)-(26,14), 15
Line (27,7)-(28,12), 15, BF
Paint(7,7),8,15

'reading values and displaying the icon
Do
	var f = FreeFile
	open "/sys/class/power_supply/battery/capacity" for input as #f
	input #f, percentage
    close #f
	open "/sys/class/power_supply/battery/status" for input as #f
	input #f, status
    close #f
    if percentage <= 20 then
		if message_shown = 0 then
		shell "xmessage -center -timeout 3 The battery is below 20%. Plug in the charger."
		message_shown = 1
		end if
    end if
    cells = percentage / 25
	if status = "discharging" then
		charge(8)
		celldraw(cells)
	end if
	if status = "charging" then
		celldraw(cells)
		charge(yellow)
	end if
	if status = "charged" then
		celldraw(cells)
		charge(15)
	end if
    Sleep(10000)
Loop