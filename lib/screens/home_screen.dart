import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../widgets/producto_card.dart';
import '../widgets/barra_navegacion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceNavegacion = 0;
  String _categoriaSeleccionada = 'Todos';
  final List<String> _categorias = [
    'Todos',
    'Electrónica',
    'Fotografía',
    'Accesorios',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(child: _buildContenidoPrincipal()),
          BarraNavegacion(
            indiceActual: _indiceNavegacion,
            onTap: (indice) {
              setState(() {
                _indiceNavegacion = indice;
              });
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.store, color: Color(0xFF7C3AED)),
          const SizedBox(width: 8),
          const Text(
            'Mi Tienda',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${screenWidth.toInt()}px',
              style: TextStyle(color: const Color(0xFF7C3AED), fontSize: 12),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  // RETO 2: LayoutBuilder detecta el ancho y cambia el layout
  Widget _buildContenidoPrincipal() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSidebar(),
              Expanded(child: _buildScrollContent(mostrarCategorias: false)),
            ],
          );
        }
        return _buildScrollContent(mostrarCategorias: true);
      },
    );
  }

  // Sidebar vertical para desktop — CORREGIDO con List.generate
  Widget _buildSidebar() {
    return Container(
      width: 250,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Categorías',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const Divider(),
          Column(
            children: List.generate(_categorias.length, (index) {
              final categoria = _categorias[index];
              final esActiva = categoria == _categoriaSeleccionada;
              return ListTile(
                leading: Icon(
                  _getIconoCategoria(categoria),
                  color: esActiva ? const Color(0xFF7C3AED) : Colors.grey[600],
                  size: 22,
                ),
                title: Text(
                  categoria,
                  style: TextStyle(
                    color: esActiva
                        ? const Color(0xFF7C3AED)
                        : Colors.grey[800],
                    fontWeight: esActiva ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                tileColor: esActiva
                    ? const Color(0xFFF3E8FF)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () {
                  setState(() {
                    _categoriaSeleccionada = categoria;
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollContent({required bool mostrarCategorias}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEncabezado(),
          const SizedBox(height: 20),
          if (mostrarCategorias) ...[
            _buildCategorias(),
            const SizedBox(height: 20),
          ],
          const Text(
            'Productos Destacados',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildGridProductos(),
        ],
      ),
    );
  }

  Widget _buildEncabezado() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Expanded(child: _buildBannerPrincipal()),
              const SizedBox(width: 16),
              Expanded(child: _buildBannerSecundario()),
            ],
          );
        }
        return _buildBannerPrincipal();
      },
    );
  }

  Widget _buildBannerPrincipal() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¡Ofertas de Temporada!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hasta 50% de descuento',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Ver ofertas'),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Icon(
              Icons.local_offer,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSecundario() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping, size: 40, color: Colors.orange[700]),
            const SizedBox(height: 8),
            Text(
              'Envío Gratis',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange[900],
              ),
            ),
            Text(
              'En compras +\$50',
              style: TextStyle(color: Colors.orange[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorias() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final esSeleccionado = _categorias[index] == _categoriaSeleccionada;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {
                setState(() => _categoriaSeleccionada = _categorias[index]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: esSeleccionado ? Colors.blue : Colors.white,
                foregroundColor: esSeleccionado ? Colors.white : Colors.black,
                elevation: esSeleccionado ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: esSeleccionado ? Colors.blue : Colors.grey[300]!,
                  ),
                ),
              ),
              child: Text(_categorias[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridProductos() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columnas;
        double childAspectRatio;

        if (constraints.maxWidth >= 1200) {
          columnas = 4;
          childAspectRatio = 0.75;
        } else if (constraints.maxWidth >= 900) {
          columnas = 3;
          childAspectRatio = 0.75;
        } else if (constraints.maxWidth >= 600) {
          columnas = 3;
          childAspectRatio = 0.7;
        } else {
          columnas = 2;
          childAspectRatio = 0.65;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnas,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: productosEjemplo.length,
          itemBuilder: (context, index) {
            return ProductoCard(producto: productosEjemplo[index]);
          },
        );
      },
    );
  }

  IconData _getIconoCategoria(String categoria) {
    switch (categoria) {
      case 'Electrónica':
        return Icons.devices;
      case 'Fotografía':
        return Icons.camera_alt;
      case 'Accesorios':
        return Icons.headset;
      default:
        return Icons.grid_view;
    }
  }
}
