# Encontrando o caminho mais curto entre 2 nodes

# Imports
from queue import Queue
from matriz import *

# Criando a tabela de distância
def build_distance_table(graph, source):
	# Um mapeamento de dicionário com o número do vértice para uma tupla de (distância da fonte, último vértice no caminho da origem)
	distance_table = {}

	for i in range(graph.numVertices):
		distance_table[i] = (None, None)

	# A distância da fonte para si mesma é 0
	distance_table[source] = (0, source)

	queue = Queue()
	queue.put(source)

	while not queue.empty():
		current_vertex = queue.get()

		# A distância do vértice atual da fonte
		current_distance = distance_table[current_vertex][0]
			
		for neighbor in graph.get_adjacent_vertices(current_vertex):
			
			# Apenas atualiza a tabela de distância se nenhuma distância atual da fonte estiver configurada
			if distance_table[neighbor][0] is None:
				distance_table[neighbor] = (1 + current_distance, current_vertex)

				# Enqueue o vizinho apenas se tiver outros vértices adjacentes para explorar
				if len(graph.get_adjacent_vertices(neighbor)) > 0:
					queue.put(neighbor)

	return distance_table			


# Algoritmo do caminho mais curto em grafos não ponderados
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
		print("\nO Caminho Mais Curto é: ", path)
		print("Tabela de Distância:", distance_table)


# Cria o grafo
g = AdjacencySetGraph(8, directed=True)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(1, 3)
g.add_edge(2, 3)
g.add_edge(1, 4)
g.add_edge(3, 5)
g.add_edge(5, 4)
g.add_edge(3, 6)
g.add_edge(6, 7)
g.add_edge(0, 7)


# Caminho mais curto entre 2 nodes
shortest_path(g, 0, 5)
shortest_path(g, 0, 6)
shortest_path(g, 7, 4)

print("\n")



















