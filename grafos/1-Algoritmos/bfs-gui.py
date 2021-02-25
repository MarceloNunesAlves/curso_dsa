# Algoritmo de Busca Breadth First

# pip install simpleguitk
import simpleguitk as simplegui 

# Constantes
B_WIDTH, B_HEIGHT = 500, 300
CIRCLE_SPACING = 75

class Node():
	circle_size = 10
	circle_lw = 20
	pos = []
	children = []
	colour = ""
	index = 0

	def set_pos(self, pos_list):
		if pos_list:
			self.pos = pos_list

	def set_children(self, child_list):
		if child_list:
			self.children = child_list

	def set_colour(self, state):
		colour_choice = {
			"visited": "red",
			"inactive": "white",
			"active": "yellow",
			"current": "black"
		}

		if state == "inactive":
			self.colour = colour_choice['inactive']
		elif state == "active":
			self.colour = colour_choice['active']
		elif state == "current":
			self.colour = colour_choice['current']
		elif state == "visited":
			self.colour = colour_choice['visited']
		else:
			self.colour = colour_choice['inactive']

	def set_index(self, index):
		if index:
			self.index = index

	def get_children(self):
		return self.children

	def __str__(self):
		return str(self.index)

a = Node() # 1
a.set_pos([B_WIDTH/2, 25])
a.set_children([1,2])
a.set_colour('inactive')

b = Node() # 2
b.set_pos([a.pos[0]-CIRCLE_SPACING, a.pos[1] + CIRCLE_SPACING])
b.set_children([3,4])
b.set_colour('inactive')
b.set_index(1)


c = Node() # 3
c.set_pos([b.pos[0]+CIRCLE_SPACING*2, a.pos[1] + CIRCLE_SPACING])
c.set_children([5,6])
c.set_colour('inactive')
c.set_index(2)

d = Node() # 4
d.set_pos([b.pos[0]-50, b.pos[1] + CIRCLE_SPACING])
d.set_colour('inactive')
d.set_index(3)

e = Node() # 5
e.set_pos([b.pos[0]+50, b.pos[1] + CIRCLE_SPACING])
e.set_children([7])
e.set_colour('inactive')
e.set_index(4)

f = Node() # 6
f.set_pos([c.pos[0]-50, c.pos[1] + CIRCLE_SPACING])
f.set_colour('inactive')
f.set_index(5)

g = Node() # 7
g.set_pos([c.pos[0]+50, c.pos[1] + CIRCLE_SPACING])
g.set_children([8,9])
g.set_colour('inactive')
g.set_index(6)

h = Node() # 8
h.set_pos([e.pos[0]-50, e.pos[1] + CIRCLE_SPACING])
h.set_colour('inactive')
h.set_index(7)

i = Node() # 9
i.set_pos([g.pos[0]-50, g.pos[1] + CIRCLE_SPACING])
i.set_colour('inactive')
i.set_index(8)

j = Node() # 10
j.set_pos([g.pos[0]+50, g.pos[1] + CIRCLE_SPACING])
j.set_colour('inactive')
j.set_index(9)

# BFS VARS
node_list = [a,b,c,d,e,f,g,h,i,j]
goal = 9
start = 0
index = 0
queue = [0]
discarded = []
complete = False


def draw(canvas):
	for node in node_list:
		canvas.draw_circle(node.pos, node.circle_size, node.circle_lw, node.colour)

def reset():
	global complete
	global queue
	global discarded

	queue = [0]
	discarded = []
	complete = False

	lbl_found.set_text('Encontrado: ' + str(complete))

	for node in node_list:
		node.set_colour('inactive')

def step():
	global complete

	if not complete:
		for node in node_list:
			if node.colour == 'yellow':
				node.set_colour('inactive')
			elif node.colour == 'black':
				node.set_colour('visited')
		current = queue.pop(0)
		lbl_current.set_text('Corrente: ' + str(current + 1))
		node_list[current].set_colour('current')

		if current == goal:
			complete = True
			lbl_found.set_text('Encontrado: ' + str(complete))
		else:
			for child in node_list[current].children:
				node_list[child].set_colour('active')
				if child not in discarded:
					queue.append(child)
					lbl_queue.set_text('Fila: ' + str(queue))
				if current not in discarded:
					discarded.append(current)
	else:
		reset()

frame = simplegui.create_frame("BFS", B_WIDTH, B_HEIGHT)
frame.set_canvas_background('GREY')
frame.set_draw_handler(draw)
lbl_queue = frame.add_label('Fila: ' + str(queue))
lbl_current = frame.add_label('Corrente: ')
lbl_found = frame.add_label('Encontrado: ' + str(complete))
timer = simplegui.create_timer(1000, step)
timer.start()
frame.start()