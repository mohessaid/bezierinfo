// the default 2nd order curve
void setupDefaultQuadratic() {
  Point[] points = {
    new Point(70,250),
    new Point(20,110),
    new Point(250,60)
  };
  curves.add(new BezierCurve(points));
}

// the default 3rd order curve
void setupDefaultCubic() {
  Point[] points = {
    new Point(120,160),
    new Point(35,200),
    new Point(220,260),
    new Point(220,40)
  };
  curves.add(new BezierCurve(points));
}

// the default 2nd order poly-curve
void setupDefaultQuadraticPoly() {
  PolyBezierCurve p = new PolyBezierCurve(true);
  p.addCurve(new BezierCurve(new Point[]{
    new Point(1/3.0*dim, 2/3.0*dim),
    new Point(1/6.0*dim, 1/2.0*dim),
    new Point(1/3.0*dim, 1/3.0*dim)
  }));
  p.addCurve(new BezierCurve(new Point[]{ ORIGIN, ORIGIN, new Point(2/3.0*dim,1/3.0*dim) }));
  p.addCurve(new BezierCurve(new Point[]{ ORIGIN, ORIGIN, new Point(2/3.0*dim,2/3.0*dim) }));
  polycurves.add(p);
}

// the default 3rd order poly-curve
void setupDefaultCubicPoly() {
  int pad = dim/3;
  float k = 0.55228;
  PolyBezierCurve p = new PolyBezierCurve(true);
  p.addCurve(new BezierCurve(new Point[]{
    new Point(dim/2, dim/2+pad),
    new Point(dim/2 + k*pad, dim/2+pad),
    new Point(dim/2 + pad, dim/2 + k*pad),
    new Point(dim/2 + pad, dim/2)
  }));
  p.addCurve(new BezierCurve(new Point[]{
    ORIGIN,
    ORIGIN,
    new Point(dim/2 + k*pad, dim/2-pad),
    new Point(dim/2, dim/2-pad)
  }));
  p.addCurve(new BezierCurve(new Point[]{
    ORIGIN,
    ORIGIN,
    new Point(dim/2-pad, dim/2-k*pad),
    new Point(dim/2-pad, dim/2)
  }));
  polycurves.add(p);
}

/**
 * Draw a bounding box
 */
void drawBoundingBox(Point[] p) {
  if(p==null) return;
  pushStyle();
  stroke(0,255,0);
  line(p[0].x,p[0].y,p[1].x,p[1].y);
  line(p[1].x,p[1].y,p[2].x,p[2].y);
  line(p[2].x,p[2].y,p[3].x,p[3].y);
  line(p[3].x,p[3].y,p[0].x,p[0].y);
  popStyle();
}

// draw all the spanlines generated by a curve
void drawSpan(BezierCurve curve, float t) {
  Point[] span = curve.generateSpan(t);
  int order = curve.order;
  if(!showSpan) return;
  int next = order+1;
  for(int c = order; c>0; c--) {
    stroke(0,map(c,1,order,255,0),map(c,1,order,0,255));
    for(int i = 0; i<c; i++) {
      line(span[next-c-1].x, span[next-c-1].y, span[next-c].x, span[next-c].y);
      ellipse(span[next-c-1].x, span[next-c-1].y, 3, 3);
      ellipse(span[next-c].x, span[next-c].y, 3, 3);
      next++;
    }
  };
}

// draw an offset curve
void drawOffset(BezierCurve curve, float distance) {
  boolean restore = showAdditionals;
  showAdditionals = false;
  for(BezierCurve b: curve.offset(-distance)) { b.draw(); }
  for(BezierCurve b: curve.offset( distance)) { b.draw(); }
  showAdditionals = restore;
}
