import 'package:flutter/material.dart';
import '../models/producto.dart';

class ProductoDetalleScreen extends StatefulWidget {
  final Producto producto;

  const ProductoDetalleScreen({super.key, required this.producto});

  @override
  State<ProductoDetalleScreen> createState() => _ProductoDetalleScreenState();
}

class _ProductoDetalleScreenState extends State<ProductoDetalleScreen> {
  bool _esFavorito = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ── Parte superior: imagen con Stack ──────────────────────────
          _buildImagenConOverlay(context),

          // ── Parte inferior: información en Column ─────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.producto.categoria,
                      style: TextStyle(
                        color: const Color(0xFF7C3AED),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Nombre
                  Text(
                    widget.producto.nombre,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Precio
                  Text(
                    '\$${widget.producto.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descripción
                  const Text(
                    'Descripción',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.producto.descripcion,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón de compra adicional
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Producto comprado!')),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text(
                        'Comprar ahora',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Botón flotante "Agregar al carrito" (esquina inferior derecha) ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Agregado al carrito')));
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Agregar al carrito'),
      ),
    );
  }

  /// Imagen grande con elementos superpuestos usando Stack + Positioned
  Widget _buildImagenConOverlay(BuildContext context) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      // STACK: superpone botones sobre la imagen
      child: Stack(
        children: [
          // ── Fondo / imagen del producto ──────────────────────────────
          Container(
            width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
            child: Icon(
              _getIcono(widget.producto.imagenUrl),
              size: 120,
              color: Colors.grey[500],
            ),
          ),

          // ── POSITIONED: badge descuento – esquina superior izquierda ─
          Positioned(
            top: 50,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '10% OFF',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          // ── POSITIONED: botón volver – esquina superior izquierda ────
          Positioned(
            top: 44,
            left: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, size: 20),
                ),
              ),
            ),
          ),

          // ── POSITIONED: ícono favorito – esquina superior derecha ────
          Positioned(
            top: 44,
            right: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  setState(() => _esFavorito = !_esFavorito);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _esFavorito ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: _esFavorito ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // ── POSITIONED: botón carrito flotante – esquina inferior derecha
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Agregado al carrito')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcono(String tipo) {
    switch (tipo) {
      case 'laptop':
        return Icons.laptop;
      case 'headphones':
        return Icons.headphones;
      case 'watch':
        return Icons.watch;
      case 'camera':
        return Icons.camera_alt;
      case 'keyboard':
        return Icons.keyboard;
      case 'mouse':
        return Icons.mouse;
      default:
        return Icons.shopping_bag;
    }
  }
}
