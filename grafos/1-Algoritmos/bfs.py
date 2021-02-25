# Algoritmo de Busca Breadth First

# Imports
from queue import Queue
from matriz import *

# Algoritmo
def breadth_first(graph, start=0):

	# Fila
	queue = Queue()
	queue.put(start)

	# Lista de nodes visitados
	visited = np.zeros(graph.numVertices)

	# Enquanto a fila não estiver vazia, obtém o próximo item
	while not queue.empty():
		vertex = queue.get()

		if visited[vertex] == 1:
			continue

		print("Visitei o node: ", vertex)
		visited[vertex] = 1

		for v in graph.get_adjacent_vertices(vertex):
			if visited[v] != 1:
				queue.put(v)


# Cria a matriz de adjacência representando um grafo qualquer
g = AdjacencyMatrixGraph(9)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(2, 7)
g.add_edge(2, 4)
g.add_edge(2, 3)
g.add_edge(1, 5)
g.add_edge(5, 6)
g.add_edge(6, 3)
g.add_edge(3, 4)
g.add_edge(6, 8)

print("\nAlgoritmo de Busca Breadth First Iniciando a Busca Pelo Node 2: ")
breadth_first(g, 2)

print("\n")


