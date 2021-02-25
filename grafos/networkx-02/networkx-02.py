# Criando e Visualizando uma Rede de Alimentos e Nutrientes

# Imports
import csv
import networkx as nx
import matplotlib.pyplot as plt
import networkx02_plotlib as viz
from networkx.drawing.nx_agraph import graphviz_layout

# Import csv
with open("networkx-02-nutrientes.csv") as infile:
    csv_reader = csv.reader(infile)
    G = nx.Graph(csv_reader)

print("\nNodes")
print(G.nodes())

# Identifica e remove self-loops
loops = G.selfloop_edges()
G.remove_edges_from(loops)

# Ajusta o nome dos nodes usando dictionary comprehension
mapping = {node: node.title() for node in G if isinstance(node, str)}
nx.relabel_nodes(G, mapping, copy=False)
print("\nNodes")
print(G.nodes())

# Definindo Atributos
nutrients = set(("B12", "Zn", "D", "B6", "A", "Se", "Ca", "Mn", "Thiamin", "Riboflavin", "C", "E", "Niacina"))

nutrient_dict = {node: (node in nutrients) for node in G}
nx.set_node_attributes(G, nutrient_dict, "nutrient")

# Prepara para desenhar
colors = ["yellow" if n[1]["nutrient"] else "pink" for n in G.nodes(data=True)]
viz.medium_attrs["node_color"] = colors

# Desenha 4 layouts em 4 subplots
_, plot = plt.subplots(2, 2)
subplots = plot.reshape(1, 4)[0]

# Define o layout dos subplots
layouts = (nx.random_layout, nx.circular_layout, nx.spring_layout, nx.spectral_layout)
titles = ("Random", "Circular", "Force-Directed", "Spectral")

# Cria a visualização
for plot, layout, title in zip(subplots, layouts, titles):
    pos = layout(G)
    nx.draw_networkx(G, pos=pos, ax=plot, with_labels=True, **viz.medium_attrs)
    plot.set_title(title)
    viz.set_extent(pos, plot)

viz.plot("nutrientes")


