import 'package:figma_client/figma_client.dart';
import 'package:figma_importer/src/parser/parser.dart';
import 'package:test/test.dart';

const _rawStyles = {
  '23:11': Style(
    key: 'key_1',
    name: 'test-style-1',
    type: StyleType.fill,
  ),
  '233:111': Style(
    key: 'key_4',
    name: 'test-style-4',
    type: StyleType.fill,
  ),
  '23:14': Style(
    key: 'key_1_4',
    name: 'test-style-1_4',
    type: StyleType.fill,
  ),
  '23:12': Style(
    key: 'key_1_2',
    name: 'test-style-1_2',
    type: StyleType.fill,
  ),
  '65:12': Style(
    key: 'key_2',
    name: 'test-style-2',
    type: StyleType.text,
  ),
  '54:1': Style(
    key: 'key_3',
    name: 'test-style-3',
    type: StyleType.effect,
  ),
  '54:2': Style(
    key: 'key_3_2',
    name: 'test-style-3_2',
    type: StyleType.effect,
  ),
};

const _nodesResponse = NodesResponse(
  name: 'test-node',
  nodes: {
    'test-key': FileResponse(
      name: 'test-file',
      document: Section(
        id: '1',
        visible: true,
        name: 'test-node-doc',
        locked: false,
        fills: [],
        strokes: [],
        opacity: 1,
        children: [
          Rectangle(
            id: 'rectangle',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.fill: '23:11'},
            exportSettings: [],
            preserveRatio: true,
            layoutGrow: 1,
            opacity: 1,
            isMask: false,
            fills: [
              Paint(
                visible: true,
                type: PaintType.solid,
                color: Color(r: 1, g: 0.5, b: 0.1, a: 1),
              ),
            ],
            fillGeometry: [],
            strokes: [],
            strokeCap: StrokeCap.none,
            strokeJoin: StrokeJoin.miter,
            strokeDashes: [],
            strokeMiterAngle: 1,
          ),
          Rectangle(
            id: 'rectangle',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.fill: '233:111'},
            exportSettings: [],
            preserveRatio: true,
            layoutGrow: 1,
            opacity: 1,
            isMask: false,
            fills: [],
            fillGeometry: [],
            strokes: [],
            strokeCap: StrokeCap.none,
            strokeJoin: StrokeJoin.miter,
            strokeDashes: [],
            strokeMiterAngle: 1,
          ),
          Rectangle(
            id: 'rectangle',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.fill: '23:12'},
            exportSettings: [],
            preserveRatio: true,
            layoutGrow: 1,
            opacity: 1,
            isMask: false,
            fills: [
              Paint(
                visible: true,
                type: PaintType.solid,
                color: Color(r: 1, g: 0.5, b: 0.1, a: 1),
              ),
            ],
            fillGeometry: [],
            strokes: [],
            strokeCap: StrokeCap.none,
            strokeJoin: StrokeJoin.miter,
            strokeDashes: [],
            strokeMiterAngle: 1,
          ),
          Text(
            id: 'text',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.text: '65:12'},
            exportSettings: [],
            preserveRatio: true,
            layoutGrow: 1,
            opacity: 1,
            isMask: false,
            fills: [],
            style: TypeStyle(
              fontFamily: 'Inter',
              fontWeight: 500,
              letterSpacing: 0.2,
              fontSize: 20,
              lineHeightPx: 20,
            ),
            fillGeometry: [],
            strokes: [],
            strokeCap: StrokeCap.none,
            strokeJoin: StrokeJoin.miter,
            strokeDashes: [],
            strokeMiterAngle: 1,
          ),
          Rectangle(
            id: 'rectangle-2',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.effect: '54:1'},
            exportSettings: [],
            preserveRatio: true,
            layoutGrow: 1,
            opacity: 1,
            isMask: false,
            fills: [],
            effects: [],
            fillGeometry: [],
            strokes: [],
            strokeCap: StrokeCap.none,
            strokeJoin: StrokeJoin.miter,
            strokeDashes: [],
            strokeMiterAngle: 1,
          ),
          Rectangle(
            id: 'rectangle-2_1',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.effect: '54:2'},
            exportSettings: [],
            preserveRatio: true,
            layoutGrow: 1,
            opacity: 1,
            isMask: false,
            fills: [],
            effects: [
              Effect(
                visible: true,
                spread: 4,
                type: EffectType.dropShadow,
                offset: Vector2D(x: 2, y: 2),
              ),
            ],
            fillGeometry: [],
            strokes: [],
            strokeCap: StrokeCap.none,
            strokeJoin: StrokeJoin.miter,
            strokeDashes: [],
            strokeMiterAngle: 1,
          ),
        ],
      ),
      styles: _rawStyles,
    ),
  },
);

const _nodesResponseWithTwoKeys = NodesResponse(
  name: 'test-node',
  nodes: {
    'test-key': FileResponse(
      name: 'test-file',
      document: Section(
        id: '1',
        visible: true,
        name: 'test-node-doc',
        locked: false,
        fills: [],
        strokes: [],
        opacity: 1,
        children: [
          Frame(
            id: '1',
            visible: true,
            locked: false,
            styles: {StyleTypeKey.fill: '23:11'},
            fills: [
              Paint(
                visible: true,
                type: PaintType.solid,
                color: Color(r: 1, g: 0.5, b: 0.1, a: 1),
              ),
            ],
            strokes: [],
            exportSettings: [],
            children: [
              Rectangle(
                id: '2:111',
                visible: true,
                locked: false,
                exportSettings: [],
                preserveRatio: true,
                layoutGrow: 1,
                opacity: 1,
                styles: {StyleTypeKey.fill: '214:141'},
                isMask: false,
                fills: [
                  Paint(
                    visible: true,
                    type: PaintType.solid,
                    color: Color(r: 1, g: 0.5, b: 0.1, a: 1),
                  ),
                ],
                fillGeometry: [],
                strokes: [],
                strokeCap: StrokeCap.none,
                strokeJoin: StrokeJoin.miter,
                strokeDashes: [],
                strokeMiterAngle: 1,
              ),
            ],
            opacity: 1,
            primaryAxisAlignItems: PrimaryAxisAlignItems.center,
            counterAxisAlignItems: CounterAxisAlignItems.center,
            primaryAxisSizingMode: PrimaryAxisSizingMode.auto,
            counterAxisSizingMode: CounterAxisSizingMode.fixed,
            paddingBottom: 0,
            paddingLeft: 0,
            paddingRight: 0,
            paddingTop: 0,
            horizontalPadding: 0,
            verticalPadding: 0,
            itemSpacing: 0,
            layoutGrids: [],
            overflowDirection: OverflowDirection.horizontalScrolling,
            effects: [],
            isMask: false,
            isMaskOutline: false,
            layoutPositioning: LayoutPositioning.absolute,
            itemReverseZIndex: false,
            strokesIncludedInLayout: false,
          ),
        ],
      ),
      styles: _rawStyles,
    ),
    'test-key-2': FileResponse(
      name: 'test-file',
      document: Section(
        id: '1',
        visible: true,
        name: 'test-node-doc',
        locked: false,
        fills: [],
        strokes: [],
        opacity: 1,
        children: [
          Frame(
            id: '2',
            visible: true,
            locked: false,
            fills: [],
            strokes: [],
            styles: {StyleTypeKey.effect: '54:1'},
            exportSettings: [],
            effects: [
              Effect(
                visible: true,
                spread: 2,
                type: EffectType.dropShadow,
                offset: Vector2D(x: 0, y: 2),
              ),
            ],
            children: [],
            opacity: 1,
            primaryAxisAlignItems: PrimaryAxisAlignItems.center,
            counterAxisAlignItems: CounterAxisAlignItems.center,
            primaryAxisSizingMode: PrimaryAxisSizingMode.auto,
            counterAxisSizingMode: CounterAxisSizingMode.fixed,
            paddingBottom: 0,
            paddingLeft: 0,
            paddingRight: 0,
            paddingTop: 0,
            horizontalPadding: 0,
            verticalPadding: 0,
            itemSpacing: 0,
            layoutGrids: [],
            overflowDirection: OverflowDirection.horizontalScrolling,
            isMask: false,
            isMaskOutline: false,
            layoutPositioning: LayoutPositioning.absolute,
            itemReverseZIndex: false,
            strokesIncludedInLayout: false,
          ),
        ],
      ),
      styles: _rawStyles,
    ),
  },
);

const _nodeResponseWithoutStyles = NodesResponse(
  name: 'test-node',
  nodes: {
    'test-key': FileResponse(
      name: 'test-file',
      document: Node(
        id: '1',
        visible: true,
        name: 'test-node-doc',
      ),
    ),
  },
);

const _styles = [
  ColorStyle(
    name: 'color',
    paint: Paint(visible: true),
  ),
  ColorStyle(
    name: 'color2',
    paint: Paint(visible: true),
  ),
  TextStyle(
    name: 'h1',
    typeStyle: TypeStyle(),
  ),
  TextStyle(
    name: 'h2',
    typeStyle: TypeStyle(),
  ),
  EffectStyle(
    name: 'effect',
    effect: [Effect(visible: true)],
  ),
  EffectStyle(
    name: 'effect-2',
    effect: [Effect(visible: true)],
  ),
];

const _styleMap = {
  StyleDefinition.color: [
    ColorStyle(
      name: 'color',
      paint: Paint(visible: true),
    ),
  ],
  StyleDefinition.shadows: [
    EffectStyle(
      name: 'effect',
      effect: [Effect(visible: false)],
    ),
    EffectStyle(
      name: 'effect-2',
      effect: [Effect(visible: false)],
    ),
  ],
  StyleDefinition.typography: [
    TextStyle(
      name: 'h1',
      typeStyle: TypeStyle(),
    ),
    TextStyle(
      name: 'h2',
      typeStyle: TypeStyle(),
    ),
  ],
};

const _paintStylesResponse = NodesResponse(
  name: 'test-node',
  nodes: {
    '23:11': FileResponse(
      document: Rectangle(
        id: '23:11',
        visible: true,
        locked: false,
        exportSettings: [],
        preserveRatio: true,
        layoutGrow: 1,
        opacity: 1,
        isMask: false,
        fills: [
          Paint(
            visible: true,
            type: PaintType.solid,
            color: Color(r: 1, g: 0.5, b: 0.1, a: 1),
          ),
        ],
        fillGeometry: [],
        strokes: [],
        strokeCap: StrokeCap.none,
        strokeJoin: StrokeJoin.miter,
        strokeDashes: [],
        strokeMiterAngle: 1,
      ),
    ),
    '23:14': FileResponse(
      document: Rectangle(
        id: '23:14',
        visible: true,
        locked: false,
        exportSettings: [],
        preserveRatio: true,
        layoutGrow: 1,
        opacity: 1,
        isMask: false,
        fills: [],
        fillGeometry: [],
        strokes: [],
        strokeCap: StrokeCap.none,
        strokeJoin: StrokeJoin.miter,
        strokeDashes: [],
        strokeMiterAngle: 1,
      ),
    ),
    '65:12': FileResponse(
      document: Text(
        id: '65:12',
        visible: true,
        locked: false,
        exportSettings: [],
        preserveRatio: true,
        layoutGrow: 1,
        opacity: 1,
        isMask: false,
        fills: [],
        style: TypeStyle(
          fontFamily: 'Inter',
          fontWeight: 500,
          letterSpacing: 0.2,
          fontSize: 20,
          lineHeightPx: 20,
        ),
        fillGeometry: [],
        strokes: [],
        strokeCap: StrokeCap.none,
        strokeJoin: StrokeJoin.miter,
        strokeDashes: [],
        strokeMiterAngle: 1,
      ),
    ),
    '54:1': FileResponse(
      document: Rectangle(
        id: '54:1',
        visible: true,
        locked: false,
        exportSettings: [],
        preserveRatio: true,
        layoutGrow: 1,
        opacity: 1,
        isMask: false,
        fills: [],
        effects: [
          Effect(
            visible: true,
            spread: 2,
            type: EffectType.dropShadow,
            offset: Vector2D(x: 0, y: 2),
          ),
        ],
        fillGeometry: [],
        strokes: [],
        strokeCap: StrokeCap.none,
        strokeJoin: StrokeJoin.miter,
        strokeDashes: [],
        strokeMiterAngle: 1,
      ),
    ),
  },
);

void main() {
  group('TokenParser', () {
    late TokenParser tokenParser;

    setUp(() {
      tokenParser = const TokenParser();
    });

    group('getStylesFromFile', () {
      test('correctly gets styles', () {
        final result = tokenParser.getStylesFromFile(_nodesResponse);
        expect(result, equals(_rawStyles));
      });

      test('correctly gets styles from node response with two keys', () {
        final result = tokenParser.getStylesFromFile(_nodesResponseWithTwoKeys);
        expect(result, equals(_rawStyles));
      });

      test('returns null if the file does not contain styles', () {
        final result =
            tokenParser.getStylesFromFile(_nodeResponseWithoutStyles);
        expect(result, equals(null));
      });
    });

    group('getStyleSets', () {
      test('correctly gets style sets', () {
        final result = tokenParser.getStyleSets(_styles);
        expect(result, equals(_styleMap));
      });

      test('returns empty Map if the styles is empty', () {
        final result = tokenParser.getStyleSets([]);
        expect(result, equals({}));
      });
    });

    group('findStylesPropertiesInPaintStyles', () {
      test('correctly gets styles', () {
        final result = tokenParser.findStylesPropertiesInPaintStyles(
          _paintStylesResponse,
          _rawStyles,
        );
        expect(
          result,
          equals(
            const [
              ColorStyle(
                name: 'test-style-1',
                paint: Paint(visible: true),
              ),
              TextStyle(
                name: 'test-style-2',
                typeStyle: TypeStyle(),
              ),
              EffectStyle(
                name: 'test-style-3',
                effect: [Effect(visible: true)],
              ),
            ],
          ),
        );
      });

      test('returns null if the styles in the node tree not found', () {
        final result = tokenParser.findStylesPropertiesInPaintStyles(
          const NodesResponse(),
          _rawStyles,
        );
        expect(result, equals(null));
      });
      test('returns empty array if the styles is empty', () {
        final result = tokenParser.findStylesPropertiesInPaintStyles(
          _paintStylesResponse,
          {},
        );
        expect(result, equals([]));
      });
    });

    group('findStylesInNodes', () {
      test('correctly find styles in the node tree', () {
        final result = tokenParser.findStylesInNodes(
          _nodesResponse,
          _rawStyles,
        );
        expect(
          result,
          equals(
            const [
              ColorStyle(
                name: 'test-style-1',
                paint: Paint(visible: true),
              ),
              ColorStyle(
                name: 'test-style-1_2',
                paint: Paint(visible: true),
              ),
              TextStyle(
                name: 'test-style-2',
                typeStyle: TypeStyle(),
              ),
              EffectStyle(
                name: 'test-style-3',
                effect: [Effect(visible: true)],
              ),
              EffectStyle(
                name: 'test-style-3_2',
                effect: [Effect(visible: true)],
              ),
            ],
          ),
        );
      });

      test('correctly find styles in the tree with two nodes', () {
        final result = tokenParser.findStylesInNodes(
          _nodesResponseWithTwoKeys,
          _rawStyles,
        );
        expect(
          result,
          equals(
            const [
              ColorStyle(
                name: 'test-style-1',
                paint: Paint(visible: true),
              ),
              EffectStyle(
                name: 'test-style-3',
                effect: [Effect(visible: true)],
              ),
            ],
          ),
        );
      });

      test('returns null if the styles not found', () {
        final result = tokenParser.findStylesInNodes(
          const NodesResponse(),
          _rawStyles,
        );
        expect(result, equals(null));
      });
    });
  });
}
