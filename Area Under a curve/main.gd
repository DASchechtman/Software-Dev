extends RichTextLabel

var i = 1.0
var a = 1.0
var b = 10.0
var n = pow(10, 10)
var change_in_x = float((b-a))/float(n)
var area = 0.0
var dist 
const file = preload('FileLoader.gd')
var func_val = 0.0
var iter = 0.0
var start_date
var end_date = ' '
var write_date = true


func _ready():
	file = file.new("user://saveArea.txt", "saveArea")
	dist = OS.get_datetime()
	start_date = str(dist["month"])+'/'+str(dist['day'])+'/'+str(dist['year'])
	for line in file.read():
		var s = line.split(':')
		if s[0] == 'startDate':
			start_date = s[1]
		elif s[0] == 'endDate':
			end_date = s[1]
		elif s[0] == 'func':
			func_val = float(s[1])
		elif s[0] == 'iter':
			iter = int(s[1])
		elif s[0] == 'area':
			area = float(s[1])
		elif s[0] == 'saveDate':
			write_date = strToBool(s[1])
	OS.set_target_fps(0)
	set_process(true)
	set_scale(Vector2(2, 2))

func strToBool(string):
	var ret = null
	if string.to_lower() == "true":
		ret = true
	elif string.to_lower() == "false":
		ret = false
	return ret

func _process(delta):
	var x_sub_i = a+(iter-1)*change_in_x
	var date = 'Start Date: '+start_date + '     End Date: '+end_date+'\n'
	var text_func = 'Func: ' + str(_equation(x_sub_i))+'\n'
	var text_iter = 'Iter: ' + str(iter)+'\n'
	var text_area = 'Area: ' + str(area)
	if iter < n:
		area += _equation(x_sub_i)*change_in_x
		iter+=1
	elif write_date:
		var d = OS.get_datetime()
		end_date = str(d['month'])+'/'+str(d['day'])+'/'+str(d['year'])
		write_date = false
	
	set_text(date+text_func+text_iter+text_area)
	file.write('area:'+str(area)+'\nfunc:'+str(_equation(x_sub_i))+'\niter:'+str(iter)+'\nstartDate:'+start_date+'\nendDate:'+end_date+'\nsaveDate:'+str(write_date))

func _equation(var x):
	return (pow(x, 10) + pow(x, 4) + (5*x) + (2*x))/(x*pow(x, 7))