/// @description movement of harambe

var xDirection;
var yDirection;

xDirection = keyboard_check(ord("D")) - keyboard_check(ord("A"));
yDirection = keyboard_check(ord("S")) - keyboard_check(ord("W"));

x += xDirection
y += yDirection




