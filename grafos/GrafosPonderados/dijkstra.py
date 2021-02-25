# Algoritmo de Dijkstra para cálculo do caminho mais curto em grafos ponderados

# Imports
import priority_dict
from matriz import *

# Tabela de distância
def build_distance_table(graph, source):
	# Um mapeamento de dicionário com o número do vértice para uma tupla de (distância da fonte, último vértice no caminho da origem)
	distance_table = {}

	for i in range(graph.numVertices):
		distance_table[i] = (None, None)

	# A distância da fonte para si mesma é 0
	distance_table[source] = (0, source)

	# Mantém o mapeamento do identificador de vértice para distância da origem.
	# Acessa o item de prioridade mais alta (distância mais baixa) primeiro
	priority_queue = priority_dict.priority_dict()
	priority_queue[source] = 0

	while len(priority_queue.keys()) > 0:
		current_vertex = priority_queue.pop_smallest()

		# A distância do vértice atual da fonte
		current_distance = distance_table[current_vertex][0]

		for neighbor in graph.get_adjacent_vertices(current_vertex):
			distance = current_distance + g.get_edge_weight(current_vertex, neighbor)

			# A última distância gravada deste vizinho da fonte
			neighbor_distance = distance_table[neighbor][0]

			# Se houver uma distância atualmente registrada da fonte e esta for maior do que a distância do novo caminho encontrado, 
			# atualiza a distância atual da fonte na tabela de distância
			if  neighbor_distance is None or neighbor_distance > distance:
				distance_table[neighbor] = (distance, current_vertex)

				priority_queue[neighbor] = distance

	return distance_table			


# Algoritmo
def shortest_path(graph, source, destination):
	distance_table = build_distance_table(graph, source)

	path = [destination]

	previous_vertex = distance_table[destination][1]
	
	while previous_vertex is not None and previous_vertex is not source:
		path = [previous_vertex] + path

		previous_vertex = distance_table[previous_vertex][1]

	if previous_vertex is None:
		print("\nNão há caminho de %d para %d" % (source, destination))
	else:
		path = [source] + path
		print("\nCaminho mais curto é: ", path)
		print(distance_table)


# Grafo
g = AdjacencyMatrixGraph(8, directed=True)
g.add_edge(0, 1, 1)
g.add_edge(1, 2, 2)
g.add_edge(1, 3, 6)
g.add_edge(2, 3, 2)
g.add_edge(1, 4, 3)
g.add_edge(3, 5, 1)
g.add_edge(5, 4, 5)
g.add_edge(3, 6, 1)
g.add_edge(6, 7, 1)
g.add_edge(0, 7, 8)


# Calcula o caminho mais curto
shortest_path(g, 0, 5)
shortest_path(g, 0, 6)
shortest_path(g, 7, 4)

print("\n")




