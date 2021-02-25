# Algoritmo Prim para encontrar a Spanning Tree

# Imports
import priority_dict
from matriz import *


# Spanning Tree
def spanning_tree(graph, source):
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

	visited_vertices = set()

	# Conjunto de arestas onde cada aresta é representada como uma string
	# "1->2": é uma aresta entre os vértices 1 e 2
	spanning_tree = set()

	while len(priority_queue.keys()) > 0:
		current_vertex = priority_queue.pop_smallest()

		# Se visitamos um vértice antes, temos todas as arestas de saída, não o processamos de novo
		if current_vertex in visited_vertices:
			continue

		visited_vertices.add(current_vertex)

		# Se o vértice atual for a fonte, ainda não cruzamos uma aresta, nenhuma aresta para adicionar a nossa árvore de expansão
		if current_vertex != source:	
			# O vértice atual está conectado pela aresta ponderada mais baixa
			last_vertex = distance_table[current_vertex][1]	

			edge = str(last_vertex) + "-->" + str(current_vertex)
			if edge not in spanning_tree:
				spanning_tree.add(edge)		

		for neighbor in graph.get_adjacent_vertices(current_vertex):
			# A distância para o vizinho é apenas o peso da aresta que liga o vizinho
			distance = g.get_edge_weight(current_vertex, neighbor)

			# A última distância gravada deste vizinho
			neighbor_distance = distance_table[neighbor][0]

			# Se este vizinho foi visto pela primeira vez ou a nova borda que liga esse vizinho é de menor peso que o último
			if  neighbor_distance is None or neighbor_distance > distance:
				distance_table[neighbor] = (distance, current_vertex)

				priority_queue[neighbor] = distance


	for edge in spanning_tree:
		print(edge)			


# Grafo
g = AdjacencyMatrixGraph(8, directed=False)
g.add_edge(0, 1, 1)
g.add_edge(1, 2, 2)
g.add_edge(1, 3, 2)
g.add_edge(2, 3, 2)
g.add_edge(1, 4, 3)
g.add_edge(3, 5, 1)
g.add_edge(5, 4, 3)
g.add_edge(3, 6, 1)
g.add_edge(6, 7, 1)
g.add_edge(7, 0, 1)


# Caminho para percorrer todos os nodes
spanning_tree(g, 3)














