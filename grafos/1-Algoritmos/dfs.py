# Algoritmo de Busca Depth First

from queue import Queue
from matriz import *

# Algoritmo
def depth_first(graph, visited, current=2):

	if visited[current] == 1:
		return

	visited[current] = 1

	print("Visitei o node: ", current)
	
	for vertex in graph.get_adjacent_vertices(current):
		depth_first(graph, visited, vertex)	


# Cria a matriz de adjacência representando um grafo qualquer
g = AdjacencyMatrixGraph(9, directed=True)
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

print("\nAlgoritmo de Busca Depth First: ")
visited = np.zeros(g.numVertices)
depth_first(g, visited)


print("\n")