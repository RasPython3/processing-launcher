// tkinter-like window

static class ANCHOR {
  static int N = 0;
  static int S = 1;
  static int E = 2;
  static int W = 3;
  static int NE = 4;
  static int NW = 5;
  static int SE = 6;
  static int SW = 7;
  static int CENTER = 8;
}

static class STATUS {
  static int NORMAL = 0;
  static int ACTIVE = 1;
  static int DISABLED = 2;
  static int PRESSED = 3;
  static int HOVERED = 4;
}

class Window extends Object {
  int id;
  int x, y;
  int width, height;
  color fg, bg;
  int status = STATUS.NORMAL;
  boolean packed = false;
  PGraphics pg;
  Window(PGraphics pg) {
    this.pg = pg;
    do {
      this.id = int(random(4096+floor(items.size()/4096)*4096));
    } while(items.containsKey(this.id));
    items.put(this.id, this);
    itemids.add(this.id);
    this.width = 0;
    this.height = 0;
    this.fg = #000000;
    this.bg = #cfcfcf;
  }
  void pack(int x, int y) {
    this.pack(x, y, ANCHOR.NW);
  }
  void pack(int x, int y, int anchor) {
    if (anchor == ANCHOR.N || anchor == ANCHOR.S || anchor == ANCHOR.CENTER) {
      this.x = round(x - this.width / 2);
    } else if (anchor == ANCHOR.E || anchor == ANCHOR.NE || anchor == ANCHOR.SE) {
      this.x = x - this.width;
    } else {
      this.x = x;
    }
    if (anchor == ANCHOR.E || anchor == ANCHOR.W || anchor == ANCHOR.CENTER) {
      this.y = round(y - this.height / 2);
    } else if (anchor == ANCHOR.S || anchor == ANCHOR.SE || anchor == ANCHOR.SW) {
      this.y = y - this.height;
    } else {
      this.y = y;
    }
    this.packed = true;
  }
  void pack_forget() {
    this.packed = false;
  }
  void destroy() {
    try {
      items.remove(this.id);
    } catch (Exception e) {}
    try {
      itemids.remove((Integer)this.id);
    } catch (Exception e) {}
  }
  void draw() {}
}

class Label extends Window {
  String text;
  PImage image = null;
  Label(PGraphics pg, PImage image) {
    super(pg);
    this.image = image;
    if (image != null) {
      this.width = image.width;
      this.height = image.height;
    }
    this.text = null;
  }
  Label(PGraphics pg, String text) {
    super(pg);
    int width = 0;
    int lines = 0;
    for (String line: split(text, "\n")) {
      lines++;
      width = max(ceil(pg.textWidth(line)), width);
    }
    this.width = ceil(width+0.5*pg.textWidth("m"));
    this.height = ceil((lines+1)*(pg.textAscent()+pg.textDescent()));
    this.text = text;
  }
  Label(PGraphics pg, String text, color fg){
    this(pg, text);
    this.fg = fg;
  }
  Label(PGraphics pg, String text, color fg, color bg){
    this(pg, text, fg);
    this.bg = bg;
  }
  Label(PGraphics pg, int width, int height, String text){
    super(pg);
    this.width = ceil((width+0.5)*pg.textWidth("m"));
    this.height = ceil((height+1)*(pg.textAscent()+pg.textDescent()));
    this.text = text;
  }
  Label(PGraphics pg, int width, int height, String text, color fg){
    this(pg, width, height, text);
    this.fg = fg;
  }
  Label(PGraphics pg, int width, int height, String text, color fg, color bg){
    this(pg, width, height, text, fg);
    this.bg = bg;
  }
  void updateText(String text) {
    this.text = text;
  }
  void draw() {
    if (this.pg != null) {
      this.pg.fill(this.bg);
      this.pg.stroke(color(255, 0, 0, 0));
      this.pg.rect(this.x, this.y, this.width, this.height);
      this.pg.fill(this.fg);
      if (this.text != null) {
        this.pg.textAlign(CENTER);
        this.pg.text(this.text, this.x + this.width / 2, this.y + this.height / 2 + (this.pg.textAscent()+this.pg.textDescent()) * (2 - this.text.split("\n").length) / 2);
      } else if (this.image != null) {
        this.pg.image(this.image, this.x, this.y);
      }
    } else {
      fill(this.bg);
      this.pg.stroke(color(255, 0, 0, 0));
      rect(this.x, this.y, this.width, this.height);
      fill(this.fg);
      textAlign(CENTER);
      text(this.text, this.x + this.width / 2, this.y + this.height / 2 + (this.pg.textAscent()+this.pg.textDescent()) * (2 - this.text.split("\n").length) / 2);
    }
  }
}

class Button extends Label {
  Button(PGraphics pg, String text) {
    super(pg, text);
  }
  Button(PGraphics pg, PImage image) {
    super(pg, image);
  }
  Button(PGraphics pg, String text, color fg) {
    super(pg, text, fg);
  }
  Button(PGraphics pg, String text, color fg, color bg) {
    super(pg, text, fg, bg);
  }
  Button(PGraphics pg, int width, int height, String text) {
    super(pg, width, height, text);
  }
  Button(PGraphics pg, int width, int height, String text, color fg) {
    super(pg, width, height, text, fg);
  }
  Button(PGraphics pg, int width, int height, String text, color fg, color bg) {
    super(pg, width, height, text, fg, bg);
  }
  void draw() {
    if (this.pg != null) {
      if (this.status == STATUS.HOVERED) {
        this.pg.fill(color(min(255, red(this.bg)+10), min(255, green(this.bg)+10), min(255, blue(this.bg)+10), alpha(this.bg)));
      } else if (this.status == STATUS.PRESSED) {
        println(alpha(this.bg), red(this.bg), green(this.bg), blue(this.bg));
        this.pg.fill(color(max(0, red(this.bg)-32), max(0, green(this.bg)-32), max(0, blue(this.bg)-32), alpha(this.bg)));
      } else {
        this.pg.fill(this.bg);
      }
      this.pg.rect(this.x, this.y, this.width, this.height);
      this.pg.fill(this.fg);
      if (this.text != null) {
        this.pg.textAlign(CENTER);
        this.pg.text(this.text, this.x + this.width / 2, this.y + this.height / 2 + (this.pg.textAscent()+this.pg.textDescent()) / 2);
      } else if (this.image != null) {
        this.pg.image(this.image, this.x, this.y);
        if (this.status == STATUS.DISABLED) {
          this.pg.fill(color(127, 127, 127, 160));
          this.pg.rect(this.x, this.y, this.width, this.height);
        }
      }
    } else {
      if (this.status == STATUS.HOVERED) {
        fill(color(min(255, red(this.bg)+10), min(255, green(this.bg)+10), min(255, blue(this.bg)+10), alpha(this.bg)));
      } else if (this.status == STATUS.PRESSED) {
        fill(color(max(0, red(this.bg)-32), max(0, green(this.bg)-32), max(0, blue(this.bg)-32), alpha(this.bg)));
      } else {
        fill(this.bg);
      }
      rect(this.x, this.y, this.width, this.height);
      fill(this.fg);
      textAlign(CENTER);
      text(this.text, this.x + this.width / 2, this.y + this.height / 2 + (this.pg.textAscent()+this.pg.textDescent()) / 2);
    }
  }
}

class CheckBox extends Label {
  boolean checked;
  CheckBox(PGraphics pg) {
    super(pg, "");
    this.width += 16;
    this.checked = false;
  }
  CheckBox(PGraphics pg, boolean checked) {
    super(pg, "");
    this.width += 16;
    this.checked = checked;
  }
  CheckBox(PGraphics pg, String text) {
    super(pg, text);
    this.width += 16;
    this.checked = false;
  }
  CheckBox(PGraphics pg, boolean checked, String text) {
    super(pg, text);
    this.width += 16;
    this.checked = checked;
  }
  CheckBox(PGraphics pg, String text, color fg) {
    super(pg, text, fg);
    this.width += 16;
    this.checked = false;
  }
  CheckBox(PGraphics pg, boolean checked, String text, color fg) {
    super(pg, text, fg);
    this.width += 16;
    this.checked = checked;
  }
  CheckBox(PGraphics pg, String text, color fg, color bg) {
    super(pg, text, fg, bg);
    this.width += 16;
    this.checked = false;
  }
  CheckBox(PGraphics pg, boolean checked, String text, color fg, color bg) {
    super(pg, text, fg, bg);
    this.width += 16;
    this.checked = checked;
  }
  CheckBox(PGraphics pg, int width, int height, String text) {
    super(pg, width, height, text);
    this.checked = false;
  }
  CheckBox(PGraphics pg, int width, int height, boolean checked, String text) {
    super(pg, width, height, text);
    this.checked = checked;
  }
  CheckBox(PGraphics pg, int width, int height, String text, color fg) {
    super(pg, width, height, text, fg);
    this.checked = false;
  }
  CheckBox(PGraphics pg, int width, int height, boolean checked, String text, color fg) {
    super(pg, width, height, text, fg);
    this.checked = checked;
  }
  CheckBox(PGraphics pg, int width, int height, String text, color fg, color bg) {
    super(pg, width, height, text, fg, bg);
    this.checked = false;
  }
  CheckBox(PGraphics pg, int width, int height, boolean checked, String text, color fg, color bg) {
    super(pg, width, height, text, fg, bg);
    this.checked = checked;
  }
  void draw() {
    if (this.pg != null) {
      this.pg.fill(this.bg);
      this.pg.stroke(color(255, 0, 0, 0));
      this.pg.rect(this.x, this.y, this.width, this.height);
      this.pg.fill(this.fg);
      this.pg.textAlign(CENTER);
      this.pg.text(this.text, this.x + this.width / 2 + 8, this.y + this.height / 2 + (this.pg.textAscent()+this.pg.textDescent()) * (2 - this.text.split("\n").length) / 2);
      this.pg.fill(255);
      this.pg.stroke(0);
      this.pg.rect(this.x, this.y + this.height / 2 - 8, 16, 16, 4);
      if (this.checked) {
        this.pg.strokeWeight(2);
        this.pg.line(this.x+3, this.y + this.height / 2, this.x+6, this.y + this.height / 2 + 5);
        this.pg.line(this.x+5, this.y + this.height / 2 + 5, this.x+12, this.y + this.height / 2 - 5);
        this.pg.strokeWeight(1);
      }
    } else {
      fill(this.bg);
      this.pg.stroke(color(255, 0, 0, 0));
      rect(this.x, this.y, this.width, this.height);
      fill(this.fg);
      textAlign(CENTER);
      text(this.text, this.x + this.width / 2 + 8, this.y + this.height / 2 + (this.pg.textAscent()+this.pg.textDescent()) * (2 - this.text.split("\n").length) / 2);
      fill(255);
      stroke(0);
      rect(this.x, this.y + this.height / 2 - 8, 16, 16, 4);
      if (this.checked) {
        strokeWeight(2);
        line(this.x+3, this.y + this.height / 2, this.x+6, this.y + this.height / 2 + 5);
        line(this.x+5, this.y + this.height / 2 + 5, this.x+14, this.y + this.height / 2 - 5);
        strokeWeight(1);
      }
    }
  }
}

class Scale extends Label {
  int value = 0;
  int minimum = 0;
  int maximum = 100;
  int resolution = 1;
  int [] nob_box = {0, 0, 0, 0};
  boolean orient = true; // true: horizonal, false: vertical ( not implemented yet )
  // for Scale, width is the length of the whole box ( if text's width is smaller than given width )
  // height is the height of the whole box
  Scale(PGraphics pg) {
    super(pg, "");
  }
  Scale(PGraphics pg, int[] range) {
    super(pg, "");
    this.width = 100;
    this.minimum = range[0];
    this.maximum = range[1];
  }
  Scale(PGraphics pg, int[] range, int resolution) {
    super(pg, "");
    this.width = 100;
    this.minimum = range[0];
    this.maximum = range[1];
    this.resolution = resolution;
  }
  Scale(PGraphics pg, String text) {
    super(pg, text);
    this.width = max(this.width, 100);
    this.height += 16;
  }
  Scale(PGraphics pg, String text, int[] range) {
    super(pg, text);
    this.width = max(this.width, 100);
    this.height += 16;
    this.minimum = range[0];
    this.maximum = range[1];
  }
  Scale(PGraphics pg, String text, int[] range, int resolution) {
    super(pg, text);
    this.width = max(this.width, 100);
    this.height += 16;
    this.minimum = range[0];
    this.maximum = range[1];
    this.resolution = resolution;
  }
  Scale(PGraphics pg, String text, color fg) {
    super(pg, text, fg);
    this.width = max(this.width, 100);
    this.height += 16;
  }
  Scale(PGraphics pg, String text, color fg, int[] range) {
    super(pg, text, fg);
    this.width = max(this.width, 100);
    this.height += 16;
    this.minimum = range[0];
    this.maximum = range[1];
  }
  Scale(PGraphics pg, String text, color fg, int[] range, int resolution) {
    super(pg, text, fg);
    this.width = max(this.width, 100);
    this.height += 16;
    this.minimum = range[0];
    this.maximum = range[1];
    this.resolution = resolution;
  }
  Scale(PGraphics pg, String text, color fg, color bg) {
    super(pg, text, fg, bg);
    this.width = max(this.width, 100);
    this.height += 16;
  }
  Scale(PGraphics pg, String text, color fg, color bg, int[] range) {
    super(pg, text, fg, bg);
    this.minimum = range[0];
    this.maximum = range[1];
  }
  Scale(PGraphics pg, String text, color fg, color bg, int[] range, int resolution) {
    super(pg, text, fg, bg);
    this.width = max(this.width, 100);
    this.height += 16;
    this.minimum = range[0];
    this.maximum = range[1];
    this.resolution = resolution;
  }
  Scale(PGraphics pg, int width, int height, String text) {
    super(pg, text);
    this.width = max(this.width, width);
    this.height += height;
  }
  Scale(PGraphics pg, int width, int height, String text, int[] range) {
    super(pg, text);
    this.width = max(this.width, width);
    this.height += height;
    this.minimum = range[0];
    this.maximum = range[1];
  }
  Scale(PGraphics pg, int width, int height, String text, int[] range, int resolution) {
    super(pg, text);
    this.width = max(this.width, width);
    this.height += height;
    this.minimum = range[0];
    this.maximum = range[1];
    this.resolution = resolution;
  }
  Scale(PGraphics pg, int width, int height, String text, color fg) {
    super(pg, text, fg);
    this.width = max(this.width, width);
    this.height += height;
  }
  Scale(PGraphics pg, int width, int height, String text, color fg, int[] range) {
    super(pg, text, fg);
    this.width = max(this.width, width);
    this.height += height;
    this.minimum = range[0];
    this.maximum = range[1];
  }
  Scale(PGraphics pg, int width, int height, String text, color fg, int[] range, int resolution) {
    super(pg, text, fg);
    this.width = max(this.width, width);
    this.height += height;
    this.minimum = range[0];
    this.maximum = range[1];
    this.resolution = resolution;
  }
  Scale(PGraphics pg, int width, int height, String text, color fg, color bg) {
    super(pg, text, fg, bg);
    this.width = max(this.width, width);
    this.height += height;
  }
  Scale(PGraphics pg, int width, int height, String text, color fg, color bg, int[] range) {
    super(pg, text, fg, bg);
    this.width = max(this.width, width);
    this.height += height;
    this.minimum = range[0];
    this.maximum = range[1];
  }
  Scale(PGraphics pg, int width, int height, String text, color fg, color bg, int[] range, int resolution) {
    super(pg, text, fg, bg);
    this.width = max(this.width, width);
    this.height += height;
    this.minimum = range[0];
    this.maximum = range[1];
    this.resolution = resolution;
  }
  int set(int value) {
    if (value >= this.minimum && value <= this.maximum) {
      this.value = value;
    } else if (value < this.minimum) {
      this.value = this.minimum;
    } else {
      this.value = this.maximum;
    }
    return this.value;
  }
  int get() {
    return this.value;
  }
  void draw() {
    int boxH;
    if (this.text.length() == 0) {
      boxH = this.height;
    } else {
      boxH = round(this.height - (split(this.text, "\n").length+1)*(this.pg.textAscent()+this.pg.textDescent()));
    }
    this.nob_box[1] = this.y + this.height - boxH + (boxH >= 2 ? 1 : 0);
    this.nob_box[2] = round(max(this.width / 10.0, this.width - this.resolution * (this.maximum - this.minimum)));
    this.nob_box[0] = round(this.x + ((this.width - this.nob_box[2]) * (this.value - this.minimum + 0.0) / (this.maximum - this.minimum + 0.0)));
    this.nob_box[3] = max(0, boxH - 2);
    if (this.pg != null) {
      this.pg.fill(this.bg);
      this.pg.stroke(color(255, 0, 0, 0));
      this.pg.rect(this.x, this.y, this.width, this.height);
      this.pg.fill(this.fg);
      this.pg.textAlign(CENTER);
      this.pg.text(this.text, this.x + this.width / 2, this.y + (this.height - boxH) / 2 + (this.pg.textAscent()+this.pg.textDescent()) * (2 - this.text.split("\n").length) / 2);
      this.pg.fill(255);
      this.pg.stroke(0);
      this.pg.rect(this.x, this.y + this.height - boxH, this.width, boxH);
      this.pg.fill(127);
      this.pg.rect(nob_box[0], nob_box[1], nob_box[2], nob_box[3]);
    } else {
      fill(this.bg);
      this.pg.stroke(color(255, 0, 0, 0));
      rect(this.x, this.y, this.width, this.height);
      fill(this.fg);
      textAlign(CENTER);
      text(this.text, this.x + this.width / 2 + 8, this.y + (this.height - boxH) / 2 + (this.pg.textAscent()+this.pg.textDescent()) * (2 - this.text.split("\n").length) / 2);
      fill(255);
      stroke(0);
      rect(this.x, this.y + this.height - boxH, this.width, boxH);
      fill(127);
      rect(nob_box[0], nob_box[1], nob_box[2], nob_box[3]);
    }
  }
}

HashMap<Integer,Window> items;
ArrayList<Integer> itemids;

static class GAME {
  static int LAUNCHER = 0;
  static int GENES = 1;
  static int PVSZ = 2;
}

int game = GAME.LAUNCHER;

/* === GENES === */

static class Gene {
  // gene: originally 8 bit ( AA BB CC DD )
  // extended 10 bit ( PPPP QQ RR SS )
  // SS RR QQ PPPP DD CC BB AA
  // AA ... probability of moving for BB, 00 : 0%, 11 : 50%
  // BB ... moving direction tendency, 00: LEFT, 01: RIGHT, 10: UP, 11: DOWN
  // CC ... required energy to reproduce, 0x1000 * 0bCC * cells.length
  // DD ... direction to add new cell, same with BB
  // PPPP ... living's smell, 4 kinds and can multiple
  // QQ ... smell that living loves.
  // RR ... smell that libing hates.
  // SS ... how well it loves/hates the smell. 00: don't care, 01: 4%, 10: 8%, 11: 12% per strength react the smell (exp. 72% react for smell strength 10)
  // total: 18 bit
  int gene;
  Gene(int gene) {
    this.gene = gene;
  }
  static Gene fromInt(int gene) {
    return new Gene(gene);
  }
  Gene clone() {
    return new Gene(this.gene);
  }
}

static class Cell {
  Gene gene;
  int rx, ry;
  Cell(Gene gene, int rx, int ry) {
    this.gene = gene;
    this.rx = rx;
    this.ry = ry;
  }
  static Cell fromInt(int gene, int rx, int ry) {
    return new Cell(Gene.fromInt(gene), rx, ry);
  }
  Cell clone() {
    return new Cell(this.gene.clone(), this.rx, this.ry);
  }
}

class Living {
  int id;
  int x;
  int y;
  int energy;
  ArrayList<Cell> cells;
  int feel; // 0: nothing, 1: love, 2: hate
  Living(int id, int x, int y, int energy, ArrayList<Cell> cells) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.energy = energy;
    this.cells = cells;
  }
  Living clone() {
    ArrayList<Cell> newcells = new ArrayList<Cell>();
    for (Cell cell:this.cells) {
      newcells.add(cell.clone());
    }
    return new Living(this.id, this.x, this.y, this.energy, newcells);
  }
}

class Food {
  int x = 0;
  int y = 0;
  Food(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

// class for drawing

class DetailInfoGroup {
  PGraphics pg;
  Label label_id, label_energy, label_cellnum, label_cell0, label_cell1, label_cell2, label_cell3, label_cell4, label_cell5, label_cell6, label_cell7, label_cell8, label_cell9;
  DetailInfoGroup(PGraphics pg) {
    this.pg = pg;
    new Label(this.pg, "Clicked\nCreat", 0, color(255, 0, 0, 0)).pack(850, 275, ANCHOR.CENTER);
    this.label_id = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_id.pack(910, 275, ANCHOR.CENTER);
    new Label(this.pg, "Life", 0, color(255, 0, 0, 0)).pack(850, 460, ANCHOR.CENTER);
    this.label_energy = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_energy.pack(910, 460, ANCHOR.CENTER);
    new Label(this.pg, "Cells", 0, color(255, 0, 0, 0)).pack(850, 480, ANCHOR.CENTER);
    this.label_cellnum = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cellnum.pack(910, 480, ANCHOR.CENTER);
    new Label(this.pg, "Gene 0", 0, color(255, 0, 0, 0)).pack(850, 510, ANCHOR.CENTER);
    this.label_cell0 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell0.pack(910, 510, ANCHOR.CENTER);
    new Label(this.pg, "Gene 1", 0, color(255, 0, 0, 0)).pack(850, 530, ANCHOR.CENTER);
    this.label_cell1 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell1.pack(910, 530, ANCHOR.CENTER);
    new Label(this.pg, "Gene 2", 0, color(255, 0, 0, 0)).pack(850, 550, ANCHOR.CENTER);
    this.label_cell2 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell2.pack(910, 550, ANCHOR.CENTER);
    new Label(this.pg, "Gene 3", 0, color(255, 0, 0, 0)).pack(850, 570, ANCHOR.CENTER);
    this.label_cell3 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell3.pack(910, 570, ANCHOR.CENTER);
    new Label(this.pg, "Gene 4", 0, color(255, 0, 0, 0)).pack(850, 590, ANCHOR.CENTER);
    this.label_cell4 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell4.pack(910, 590, ANCHOR.CENTER);
    new Label(this.pg, "Gene 5", 0, color(255, 0, 0, 0)).pack(850, 610, ANCHOR.CENTER);
    this.label_cell5 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell5.pack(910, 610, ANCHOR.CENTER);
    new Label(this.pg, "Gene 6", 0, color(255, 0, 0, 0)).pack(850, 630, ANCHOR.CENTER);
    this.label_cell6 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell6.pack(910, 630, ANCHOR.CENTER);
    new Label(this.pg, "Gene 7", 0, color(255, 0, 0, 0)).pack(850, 650, ANCHOR.CENTER);
    this.label_cell7 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell7.pack(910, 650, ANCHOR.CENTER);
    new Label(this.pg, "Gene 8", 0, color(255, 0, 0, 0)).pack(850, 670, ANCHOR.CENTER);
    this.label_cell8 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell8.pack(910, 670, ANCHOR.CENTER);
    new Label(this.pg, "Gene 9", 0, color(255, 0, 0, 0)).pack(850, 690, ANCHOR.CENTER);
    this.label_cell9 = new Label(this.pg, 6, 1, "", 0, 255);
    this.label_cell9.pack(910, 690, ANCHOR.CENTER);
  }
  void update(Living living) {
    if (living == null) {
      this.label_id.updateText("");
      this.label_energy.updateText("");
      this.label_cellnum.updateText("");
      this.label_cell0.updateText("");
      this.label_cell1.updateText("");
      this.label_cell2.updateText("");
      this.label_cell3.updateText("");
      this.label_cell4.updateText("");
      this.label_cell5.updateText("");
      this.label_cell6.updateText("");
      this.label_cell7.updateText("");
      this.label_cell8.updateText("");
      this.label_cell9.updateText("");
    } else {
      this.label_id.updateText(str(living.id));
      this.label_energy.updateText(str(living.energy));
      this.label_cellnum.updateText(str(living.cells.size()));
      this.label_cell0.updateText(hex(living.cells.get(0).gene.gene, 5));
      if (living.cells.size() > 1) {
        this.label_cell1.updateText(hex(living.cells.get(1).gene.gene, 5));
        if (living.cells.size() > 2) {
          this.label_cell2.updateText(hex(living.cells.get(2).gene.gene, 5));
          if (living.cells.size() > 3) {
            this.label_cell3.updateText(hex(living.cells.get(3).gene.gene, 5));
            if (living.cells.size() > 4) {
              this.label_cell4.updateText(hex(living.cells.get(4).gene.gene, 5));
              if (living.cells.size() > 5) {
                this.label_cell5.updateText(hex(living.cells.get(5).gene.gene, 5));
                if (living.cells.size() > 6) {
                  this.label_cell6.updateText(hex(living.cells.get(6).gene.gene, 5));
                  if (living.cells.size() > 7) {
                    this.label_cell7.updateText(hex(living.cells.get(7).gene.gene, 5));
                    if (living.cells.size() > 8) {
                      this.label_cell8.updateText(hex(living.cells.get(8).gene.gene, 5));
                      if (living.cells.size() > 9) {
                        this.label_cell9.updateText(hex(living.cells.get(9).gene.gene, 5));
                      } else {
                        this.label_cell9.updateText("");
                      }
                    } else {
                      this.label_cell8.updateText("");
                      this.label_cell9.updateText("");
                    }
                  } else {
                    this.label_cell7.updateText("");
                    this.label_cell8.updateText("");
                    this.label_cell9.updateText("");
                  }
                } else {
                  this.label_cell6.updateText("");
                  this.label_cell7.updateText("");
                  this.label_cell8.updateText("");
                  this.label_cell9.updateText("");
                }
              } else {
                this.label_cell5.updateText("");
                this.label_cell6.updateText("");
                this.label_cell7.updateText("");
                this.label_cell8.updateText("");
                this.label_cell9.updateText("");
              }
            } else {
              this.label_cell4.updateText("");
              this.label_cell5.updateText("");
              this.label_cell6.updateText("");
              this.label_cell7.updateText("");
              this.label_cell8.updateText("");
              this.label_cell9.updateText("");
            }
          } else {
            this.label_cell3.updateText("");
            this.label_cell4.updateText("");
            this.label_cell5.updateText("");
            this.label_cell6.updateText("");
            this.label_cell7.updateText("");
            this.label_cell8.updateText("");
            this.label_cell9.updateText("");
          }
        } else {
          this.label_cell2.updateText("");
          this.label_cell3.updateText("");
          this.label_cell4.updateText("");
          this.label_cell5.updateText("");
          this.label_cell6.updateText("");
          this.label_cell7.updateText("");
          this.label_cell8.updateText("");
          this.label_cell9.updateText("");
        }
      } else {
        this.label_cell1.updateText("");
        this.label_cell2.updateText("");
        this.label_cell3.updateText("");
        this.label_cell4.updateText("");
        this.label_cell5.updateText("");
        this.label_cell6.updateText("");
        this.label_cell7.updateText("");
        this.label_cell8.updateText("");
        this.label_cell9.updateText("");
      }
    }
  }
}

static class MODE {
  static int NORMAL = 0;
  static int CLASSIC = 1;
}

int mode = MODE.NORMAL;

ArrayList<Living> livings;
IntList livingIds;
ArrayList<Food> foods;// = new ArrayList<Living>();
PGraphics root, menubar, field_pg, detail_pg;
DetailInfoGroup detailInfo;

int food_max = 4096;
int mutation_percent = 10; // (100/mutation_percent) %
boolean multi_predator; // 多細胞生物は捕食者か
boolean multi_omnivorous; // 多細胞生物は雑食(Foodも食べる)か

Living detailedLiving = null;

boolean initial_draw;
boolean just_draw = false;
boolean stoped;

Button startbtn, stopbtn, loadbtn, savebtn;
Scale fdmaxscl, mutationscl;
CheckBox chbox_predator, chbox_omnivorous, chbox_classic;
Label plives, pfoods;

Window pressedWindow = null;
Window releasedWindow = null;

int[] fdmaxrange = {500, 4096};
int[] mutationrange = {0, 100};

// temporary map for smell
int[][][] smellMap = new int[800][800][4];

/* === pvsz === */

class Thing {
  int type;
  int interval = 0;
  int position[];
  float heart; // HP
  float bullet; // strength of bullet
  float attack; // strength of physical attack
  float guard; // guard
  Label label; // character label

  int freezed = 0;
  Thing(Label label, int type, int position[], float heart, float bullet, float attack, float guard, int interval) {
    this.type = type;
    this.label = label;
    this.heart = heart;
    this.bullet = bullet;
    this.attack = attack;
    this.guard = guard;
    this.interval = interval;
    this.position = position;
  }
  void freeze() {
    this.freezed = round(random(100)) + 310;
  }
  void melt() {
    if (this.freezed > 0) {
      this.freezed--;
    }
  }
  void damage(float damage) {
    this.heart -= damage / guard;
    if (this.heart <= 0) {
      // die
      this.die();
    }
  }
  void die() {}
}

class Friend extends Thing {
  Friend(Label label, int type, int position[], float heart, float bullet, float attack, float guard, int interval) {
    super(label, type, position, heart, bullet, attack, guard, interval);
  }
  void die() {
    fieldMap[position[1]][position[0]] = 0;
    label.image = null;
    friends.remove(this);
  }
}

class Enemy extends Thing {
  float speed;
  float position[];
  int size;
  Enemy(Label label, int type, float position[], float heart, float bullet, float attack, float guard, int interval, float speed, int size) {
    super(label, type, null, heart, bullet, attack, guard, interval);
    this.speed = speed;
    this.position = position;
    this.size = size;
  }
  void freeze() {
    if (this.freezed <= 0) {
      this.label.image = assets[2][this.type].copy();
      for (int i = 0; i < this.label.image.pixels.length; i++) {
        this.label.image.pixels[i] = color(red(this.label.image.pixels[i]) * 0.75, green(this.label.image.pixels[i]) * 0.75 + 255 * 0.15, blue(this.label.image.pixels[i]) * 0.6 + 255 * 0.4, alpha(this.label.image.pixels[i]));
      }
    }
    super.freeze();
  }
  void melt() {
    super.melt();
    if (this.freezed <= 0) {
      this.label.image = assets[2][this.type];
    }
  }
  void die() {
    label.destroy();
    enemies.remove(this);
    exp += 5;
  }
}

class Sun {
  Label label;
  int power;
  float position[];
  float speed;
  Sun(Label label, int power, float position[], float speed) {
    this.label = label;
    this.power = power;
    this.position = position;
    this.speed = speed;
  }
}

class Bullet {
  Label label;
  float damage;
  float position[];
  boolean freeze;
  Bullet(Label label, float position[], float damage, boolean freeze) {
    this.label = label;
    this.damage = damage;
    this.position = position;
    this.freeze = freeze;
  }
}

int getCost(int type) {
  switch (type) {
    case 1:
      return 100;
    case 2:
      return 50;
    case 3:
      return 70;
    case 4:
      return 150;
    case 5:
      return 50;
    case 6:
      return 200;
  }
  return -1;
}

Friend createFriend(int type, int position[], Label label) {
  switch (type) {
    case 1:
      return new Friend(label, type, position, 100.0, 20.0, 10.0, 1.0, 60);
    case 2:
      return new Friend(label, type, position, 75.0, 1.0, 5.0, 0.9, 500);
    case 3:
      return new Friend(label, type, position, 100.0, 0.0, 0.0, 20.0, 100);
    case 4:
      return new Friend(label, type, position, 65535.0, 0.0, 0.0, 65535.0, 75);
    case 5:
      return new Friend(label, type, position, 65535.0, 0.0, 0.0, 65535.0, 150);
    case 6:
      return new Friend(label, type, position, 100.0, 20.0, 10.0, 1.0, 60);
  }
  return null;
}

Enemy createEnemy(int type, int position[]) {
  Label label = new Label(root, assets[2][type]); //images[2][type]
  label.bg = color(255, 0, 0, 0);
  /*for (int k = 0; k < label.image.pixels.length; k++) {
    label.image.pixels[k] = color(255, 90, 102, 255 - 3*(k % label.image.width)); 
  }*/
  label.pack(position[0] * 64 + 64 + label.image.width / 2, position[1] * 64 + 96, ANCHOR.CENTER);
  switch (type) {
    case 1:
      return new Enemy(label, type, new float[]{float(position[0]), float(position[1])}, 100.0, 0.0, 12.0, 1.0, 100, 0.25, 1);
    case 2:
      return new Enemy(label, type, new float[]{float(position[0]), float(position[1])}, 150.0, 0.0, 15.0, 1.0, 100, 0.15, 1);
    case 3:
      return new Enemy(label, type, new float[]{float(position[0]), float(position[1])}, 70.0, 0.0, 10.0, 1.0, 100, 0.4, 1);
    case 4:
      return new Enemy(label, type, new float[]{float(position[0]), float(position[1])}, 100.0, 0.0, 6.0, 3.0, 100, 0.2, 1);
    case 5:
      return new Enemy(label, type, new float[]{float(position[0]), float(position[1])}, 2500.0, 0.0, 30.0, 5.0, 100, 0.1, 4);
  }
  label.destroy();
  return null;
}

// friend list
// 0 ... nothing
// 1 ... smally
// 2 ... sunny
// 3 ... rocky
// 4 ... bommy
// 5 ... minny
// 6 ... freezy

// enemy list
// 1 ... zombie
// 2 ... strong zombie

int money = 50;
int moneyInterval = 30;

float heart = 10000.0;

int level = 1;
int exp = 0;
PImage assets[][] = new PImage[3][8];

int fieldMap[][] = new int[5][8];
Label tiles[][] = new Label[5][8];
Button generators[] = new Button[16];

int cooldowns[][] = new int[][]{
  {0, 1000},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100},
  {0, 100}
};

Label levelLabel, expLabel, moneyLabel, heartLabel;

ArrayList<Sun> suns = new ArrayList<Sun>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Friend> friends = new ArrayList<Friend>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

int draggedWho = 0;
Label draggedItem = null;
boolean dragging = false;

/* === Launcher === */

Button btn_genes, btn_pvsz;

void setup() {
  size(640, 480);
  items = new HashMap<Integer,Window>();
  itemids = new ArrayList<Integer>();
  root = createGraphics(640, 480);
  root.beginDraw();
  btn_genes = new Button(root, 12, 6, "Play Genes");
  btn_pvsz = new Button(root, 12, 6, "Play P vs Z");
  btn_genes.pack(192, 240, ANCHOR.CENTER);
  btn_pvsz.pack(448, 240, ANCHOR.CENTER);
  root.endDraw();
}

void launch_game(int game_id) {
  for (int id: itemids) {
    items.get(id).destroy();
  }
  game = game_id;
  if (game == GAME.GENES) {
    setup_genes();
  } else if (game == GAME.PVSZ) {
    setup_pvsz();
  }
}

void setup_genes() {
  windowResize(965, 840);
  noSmooth();
  frameRate(180);
  livings = new ArrayList<Living>();
  livingIds = new IntList();
  foods = new ArrayList<Food>();
  multi_predator = true;
  multi_omnivorous = false;
  for (int i=1; i<=10; i++) {
    ArrayList<Cell> cells = new ArrayList<Cell>();
    cells.add(Cell.fromInt(0x001d0, 0, 0));
    livings.add(new Living(i, 400, 400, 0x1fff, cells));
    livingIds.append(i);
  }
  //println(livings);
  root = createGraphics(965, 810);
  menubar = createGraphics(965, 30);
  field_pg = createGraphics(810, 810);
  detail_pg = createGraphics(140, 140);
  initial_draw = true;
  stoped = true;
  field_pg.beginDraw();
  initial_draw = false;
  field_pg.fill(0, 0, 0);
  field_pg.rect(5, 5, 800, 800);
  field_pg.endDraw();
  root.beginDraw();
  startbtn = new Button(root, 5, 1, "start");
  stopbtn = new Button(root, 5, 1, "stop");
  startbtn.pack(850, 25, ANCHOR.CENTER);
  stopbtn.pack(910, 25, ANCHOR.CENTER);
  new Label(root, "Lives", #000000, color(255, 0, 0, 0)).pack(850, 55, ANCHOR.CENTER);
  new Label(root, "Foods", #000000, color(255, 0, 0, 0)).pack(850, 80, ANCHOR.CENTER);
  plives = new Label(root, 6, 1, "0", #000000, #ffffff);
  pfoods = new Label(root, 6, 1, "0", #000000, #ffffff);
  plives.pack(910, 55, ANCHOR.CENTER);
  pfoods.pack(910, 80, ANCHOR.CENTER);
  fdmaxscl = new Scale(root, 140, 16, "FoodsMAX: 500", #ffffff, #7f7f7f, fdmaxrange, 1);
  fdmaxscl.set(500);
  fdmaxscl.pack(885, 110, ANCHOR.CENTER);
  mutationscl = new Scale(root, 140, 16, "Mutation(1/n): 10", #ffffff, #7f7f7f, mutationrange, 1);
  mutationscl.set(10);
  mutationscl.pack(885, 150, ANCHOR.CENTER);
  chbox_predator = new CheckBox(root, true, "Multicellular is Predetor", #ffffff, #7f7f7f);
  chbox_omnivorous = new CheckBox(root, false, "Omnivoroes Predetor", #ffffff, #7f7f7f);
  chbox_predator.pack(885, 185, ANCHOR.CENTER);
  chbox_omnivorous.pack(885, 205, ANCHOR.CENTER);
  chbox_classic = new CheckBox(root, false, "Classic Mode", #ffffff, #7f7f7f);
  chbox_classic.pack(885, 235, ANCHOR.CENTER);
  detailInfo = new DetailInfoGroup(root);
  root.endDraw();
  menubar.beginDraw();
  loadbtn = new Button(menubar, 7, 1, "load...");
  savebtn = new Button(menubar, 7, 1, "save...");
  loadbtn.pack(45, 15, ANCHOR.CENTER);
  savebtn.pack(125, 15, ANCHOR.CENTER);
  menubar.endDraw();
}

void setup_pvsz() {
  windowResize(640, 384);
  frameRate(60);

  // load assets
  for (int i=0; i < 8; i++) {
    try {
      assets[0][i] = loadImage("objs\\" + i + ".png");
    } catch (Exception e) {
      ;
    }
    if (assets[0][i] == null) {
      try {
        assets[0][i] = loadImage("https://github.com/RasPython3/pvsz-images/blob/main/objs/" + i +".png?raw=true", "png");
      } catch (Exception e) {
        ;
      }
    }
    if (assets[0][i] == null) {
      assets[0][i] = createImage(64, 64, ARGB);
    }
  }
  for (int i=0; i < 8; i++) {
    try {
      assets[1][i] = loadImage("friends\\" + i + ".png");
    } catch (Exception e) {
      ;
    }
    if (assets[1][i] == null) {
      try {
        assets[1][i] = loadImage("https://github.com/RasPython3/pvsz-images/blob/main/friends/" + i +".png?raw=true", "png");
      } catch (Exception e) {
        ;
      }
    }
    if (assets[1][i] == null) {
      assets[1][i] = createImage(64, 64, ARGB);
    }
  }
  for (int i=0; i < 8; i++) {
    try {
      assets[2][i] = loadImage("enemies\\" + i + ".png");
    } catch (Exception e) {
      ;
    }
    if (assets[2][i] == null) {
      try {
        assets[2][i] = loadImage("https://github.com/RasPython3/pvsz-images/blob/main/enemies/" + i +".png?raw=true", "png");
      } catch (Exception e) {
        ;
      }
    }
    if (assets[2][i] == null) {
      assets[2][i] = createImage(64, 64, ARGB);
    }
  }
  
  root = createGraphics(640, 384);
  root.beginDraw();
  
  // create info
  new Label(root, 8, 1, "").pack(8, 8, ANCHOR.W);
  new Label(root, 8, 1, "").pack(8, 32, ANCHOR.W);
  new Label(root, 8, 1, "").pack(8, 56, ANCHOR.W);
  new Label(root, "Lv :").pack(8, 8, ANCHOR.W);
  new Label(root, "Exp:").pack(8, 32, ANCHOR.W);
  new Label(root, "Sun:").pack(8, 56, ANCHOR.W);
  levelLabel = new Label(root, str(level));
  levelLabel.pack(88, 8, ANCHOR.E);
  expLabel = new Label(root, str(exp));
  expLabel.pack(88, 32, ANCHOR.E);
  moneyLabel = new Label(root, str(money));
  moneyLabel.pack(88, 56, ANCHOR.E);

  // create tiles
  for (int i = 0; i < 5; i++) {
    for (int k = 0; k < 8; k++) {
      tiles[i][k] = new Label(root, createImage(64, 64, ARGB));
      tiles[i][k].bg = color(255, 0, 0, 0);
      tiles[i][k].pack(k*64 + 64, i*64+64);
      fieldMap[i][k] = 0;
    }
  }
  
  // create generate buttons
  for (int i = 0; i < 6; i++) {
    Button btn = new Button(root, assets[1][i+1]);
    btn.pack(i*64+96, 0);
    generators[i] = btn;
    btn.status = STATUS.DISABLED;
  }

  root.endDraw();
}


// x offset from left side of the nob of the pressed scale
int nobOffset = 0;

boolean pressedKeys[] = {false, false, false};

float cannon_position = 2.0;

void keyPressed() {
  if (game != GAME.PVSZ) {
    return;
  }
  if (key == CODED) {
    if (keyCode == UP) {
      if (!pressedKeys[1]) {
        cannon_position = max(cannon_position - 0.25, 0.0);
      }
      pressedKeys[1] = true;
    } else if (keyCode == DOWN) {
      if (!pressedKeys[2]) {
        cannon_position = min(cannon_position + 0.25, 4.0);
      }
      pressedKeys[2] = true;
    }
  } else if (key == 32) {
    if (!pressedKeys[0]) {
      // handle user attack
      if (cooldowns[0][0] <= 0) {
        cooldowns[0][0] = cooldowns[0][1];
        Label label = new Label(root, createImage(48, 48, ARGB));
        for (int k = 0; k < label.image.pixels.length; k++) {
          label.image.pixels[k] = color(0, 0, 0, 3*(k % label.image.width));
        }
        Bullet bullet = new Bullet(label, new float[]{-0.5, cannon_position}, 100.0, false);
        bullets.add(bullet);
        label.pack(96, round(bullet.position[1] * 64) + 96, ANCHOR.CENTER);
      }
    }
    pressedKeys[0] = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      pressedKeys[1] = false;
    } else if (keyCode == DOWN) {
      pressedKeys[2] = false;
    }
  } else if (key == 32) {
    pressedKeys[0] = false;
  }
}

void mouseMoved() {
  int pmX = pmouseX;
  int pmY = pmouseY;
  int mX = mouseX;
  int mY = mouseY;
  println(mX, mY);
  if (game == GAME.LAUNCHER || game == GAME.PVSZ) {
    for (int id:itemids) {
      if (game == GAME.LAUNCHER) {
        boolean ignore = false;
        for (Friend friend: friends) {
          if (friend.label.id == id) {
            ignore = true;
            break;
          }
        }
        if (ignore) {
          continue;
        }
        for (Enemy enemy: enemies) {
          if (enemy.label.id == id) {
            ignore = true;
            break;
          }
        }
        if (ignore) {
          continue;
        }
      }
      Window w = items.get(id);
      if (w.x <= pmX && w.x + w.width >= pmX && w.y <= pmY && w.y + w.height >= pmY) {
        if (!(w.x <= mX && w.x + w.width >= mX && w.y <= mY && w.y + w.height >= mY || w.status == STATUS.DISABLED)) {
          w.status = STATUS.NORMAL;
        }
      } else if (w.x <= mX && w.x + w.width >= mX && w.y <= mY && w.y + w.height >= mY) {
        if (w.status != STATUS.DISABLED) {
          if (w == pressedWindow) {
            w.status = STATUS.PRESSED;
          } else if (!mousePressed) {
            w.status = STATUS.HOVERED;
          }
        }
      }
    }
  } else if (game == GAME.GENES) {
    for (int id:itemids) {
      Window w = items.get(id);
      if (w.x <= pmX && w.x + w.width >= pmX && (w.pg == root ? w.y + 30 : w.y) <= pmY && (w.pg == root ? w.y + 30 : w.y) + w.height >= pmY) {
        if (!(w.x <= mX && w.x + w.width >= mX && (w.pg == root ? w.y + 30 : w.y) <= mY && (w.pg == root ? w.y + 30 : w.y) + w.height >= mY)) {
          w.status = STATUS.NORMAL;
        }
      } else if (w.x <= mX && w.x + w.width >= mX && (w.pg == root ? w.y + 30 : w.y) <= mY && (w.pg == root ? w.y + 30 : w.y) + w.height >= mY) {
        if (w == pressedWindow) {
          w.status = STATUS.PRESSED;
        } else if (!mousePressed) {
          w.status = STATUS.HOVERED;
        }
      }
    }
  }
}

void mouseDragged() {
  if (pressedWindow == null) {
    return;
  }
  if (game == GAME.PVSZ) {
    if (!dragging) {
      int i = 1;
      for (Button btn: generators) {
        if (btn != null && pressedWindow.id == btn.id && btn.status != STATUS.DISABLED && money >= getCost(i) && cooldowns[i][0] <= 0) {
          dragging = true;
          draggedWho = i;
          draggedItem = new Label(btn.pg, btn.image);
          draggedItem.bg = color(255, 0, 0, 0);
          draggedItem.pack(mouseX, mouseY, ANCHOR.CENTER);
          break;
        }
        i++;
      }
    } else {
      draggedItem.x = mouseX - draggedItem.width / 2;
      draggedItem.y = mouseY - draggedItem.height / 2;
    }
  }
  if (pressedWindow.getClass().getSimpleName().equals("Scale") && pressedWindow.status == STATUS.PRESSED) {
    Scale w = (Scale)pressedWindow;
    int value = round((w.maximum - w.minimum) * ((mouseX - w.x - nobOffset + 0.0) / (w.width - w.nob_box[2])) + w.minimum);
    w.set(value);
    if (game == GAME.GENES) {
      if (w == fdmaxscl) {
        w.text = "FoodsMAX: " + str(w.get());
        food_max = w.get();
      } else if (w == mutationscl) {
        w.text = "Mutation(1/n): " + str(w.get());
        mutation_percent = w.get();
      }
    }
  } else if (!dragging) {
    mouseMoved();
  }
}

void mousePressed() {
  int mX = mouseX;
  int mY = mouseY;
  pressedWindow = null;
  if (game == GAME.LAUNCHER || game == GAME.PVSZ) {
    for (int id:itemids) {
      if (game == GAME.PVSZ) {
        boolean ignore = false;
        for (Friend friend: friends) {
          if (friend.label.id == id) {
            ignore = true;
            break;
          }
        }
        if (ignore) {
          continue;
        }
        for (Enemy enemy: enemies) {
          if (enemy.label.id == id) {
            ignore = true;
            break;
          }
        }
        if (ignore) {
          continue;
        }
      }
      Window w = items.get(id);
      if (w.x <= mX && w.x + w.width >= mX && w.y <= mY && w.y + w.height >= mY) {
        pressedWindow = w;
      }
    }
    if (pressedWindow != null) {
      if (!pressedWindow.getClass().getSimpleName().equals("Scale")) {
        if (pressedWindow.status != STATUS.DISABLED) {
          pressedWindow.status = STATUS.PRESSED;
        }
      } else {
        Scale scl = (Scale)pressedWindow;
        if (scl.nob_box[0] <= mX && scl.nob_box[0] + scl.nob_box[2] >= mX && scl.nob_box[1] <= mY && scl.nob_box[1] + scl.nob_box[3] >= mY) {
          if (scl.status != STATUS.DISABLED) {
            scl.status = STATUS.PRESSED;
            nobOffset = mX - scl.nob_box[0];
          }
        }
      }
    }
  } else if (game == GAME.GENES) {
    for (int id:itemids) {
      Window w = items.get(id);
      if (w.x <= mX && w.x + w.width >= mX && (w.pg == root ? w.y + 30 : w.y) <= mY && (w.pg == root ? w.y + 30 : w.y) + w.height >= mY) {
        pressedWindow = w;
      }
    }
    if (pressedWindow != null) {
      if (!pressedWindow.getClass().getSimpleName().equals("Scale")) {
        pressedWindow.status = STATUS.PRESSED;
      } else {
        Scale scl = (Scale)pressedWindow;
        if (scl.nob_box[0] <= mX && scl.nob_box[0] + scl.nob_box[2] >= mX && scl.nob_box[1] + (scl.pg == root ? 30 : 0) <= mY && scl.nob_box[1] + scl.nob_box[3] + (scl.pg == root ? 30 : 0) >= mY) {
          scl.status = STATUS.PRESSED;
          nobOffset = mX - scl.nob_box[0];
        }
      }
    }
  }
}

void mouseReleased() {
  int mX = mouseX;
  int mY = mouseY;
  releasedWindow = null;
  if (game == GAME.LAUNCHER) {
    for (int id:itemids) {
      Window w = items.get(id);
      if (w.x <= mX && w.x + w.width >= mX && w.y <= mY && w.y + w.height >= mY) {
        releasedWindow = w;
      }
    }
    if (pressedWindow != null && pressedWindow.status != STATUS.DISABLED) {
      pressedWindow.status = STATUS.NORMAL;
    }
    if (releasedWindow != null && releasedWindow.status != STATUS.DISABLED) {
      releasedWindow.status = STATUS.HOVERED;
    }
    if (pressedWindow != null) {
      if (pressedWindow == btn_genes && releasedWindow == btn_genes) {
        print("Starting Genes...");
        launch_game(GAME.GENES);
      } else if (pressedWindow == btn_pvsz && releasedWindow == btn_pvsz) {
        print("Starting pvsz...");
        launch_game(GAME.PVSZ);
      }
    }
  } else if (game == GAME.PVSZ) {
    Sun sun = null;
    boolean isSun = false;
    for (int id:itemids) {
      if (draggedItem != null && draggedItem.id == id) {
        continue;
      }
      Window w = items.get(id);
      if (w.x <= mX && w.x + w.width >= mX && w.y <= mY && w.y + w.height >= mY) {
        boolean ok = false;
        for (Bullet bullet: bullets) {
          if (w.id == bullet.label.id) {
            ok = false;
            break;
          }
        }
        for (Sun _sun: suns) {
          if (w.id == _sun.label.id) {
            isSun = true;
            sun = _sun;
            ok = true;
            break;
          }
        }
        for (int i = 0; !ok && i < 5; i++) {
          for (int k = 0; !ok && k < 8; k++) {
            if (tiles[i][k].id == w.id) {
              ok = true;
              break;
            }
          }
        }
        if (ok) {
          releasedWindow = w;
        }
      }
    }
    if (pressedWindow != null && pressedWindow.status != STATUS.DISABLED) {
      pressedWindow.status = STATUS.NORMAL;
    }
    if (releasedWindow != null && releasedWindow.status != STATUS.DISABLED) {
      releasedWindow.status = STATUS.HOVERED;
    }
    println(pressedWindow, releasedWindow);
    if (isSun && sun != null) {
      suns.remove(sun);
      sun.label.destroy();
      money += sun.power;
    }
    if (dragging) {
      dragging = false;
      if (!isSun && pressedWindow != null && releasedWindow != null && pressedWindow.status != STATUS.DISABLED) {
        for (int i = 0; i < 5; i++) {
          for (int k = 0; k < 8; k++) {
            if (tiles[i][k].id == releasedWindow.id) {
              if (fieldMap[i][k] == 0 && money >= getCost(draggedWho) && cooldowns[draggedWho][0] <= 0) {
                fieldMap[i][k] = draggedWho;
                tiles[i][k].image = draggedItem.image;
                money -= getCost(draggedWho);
                friends.add(createFriend(draggedWho, new int[]{k, i}, tiles[i][k]));
                cooldowns[draggedWho][0] = cooldowns[draggedWho][1];
              }
              break;
            }
          }
        }
      }
      draggedItem.destroy();
      draggedItem = null;
    } else {
    }
  } else if (game == GAME.GENES) {
    for (int id:itemids) {
      Window w = items.get(id);
      if (w.x <= mX && w.x + w.width >= mX && (w.pg == root ? w.y + 30 : w.y) <= mY && (w.pg == root ? w.y + 30 : w.y) + w.height >= mY) {
        releasedWindow = w;
      }
    }
    if (pressedWindow != null) {
      pressedWindow.status = STATUS.NORMAL;
    }
    if (releasedWindow != null) {
      releasedWindow.status = STATUS.HOVERED;
    }
    if (pressedWindow != null) {
      if (pressedWindow == startbtn && releasedWindow == startbtn) {
        stoped = false;
        print("start clicked\n");
      } else if (pressedWindow == stopbtn && releasedWindow == stopbtn) {
        stoped = true;
        print("stop clicked\n");
      } else if (pressedWindow == loadbtn && releasedWindow == loadbtn) {
        stoped = true;
        selectInput("Select savedata", "loadSave");
      } else if (pressedWindow == savebtn && releasedWindow == savebtn) {
        stoped = true;
        selectInput("Select savedata", "writeSave");
      } else if (pressedWindow == stopbtn && releasedWindow == stopbtn) {
        stoped = true;
        print("stop clicked\n");
      } else if (pressedWindow == releasedWindow && pressedWindow.getClass().getSimpleName().equals("CheckBox")) { // checkbox
        CheckBox checkbox = (CheckBox)pressedWindow;
        checkbox.checked = !checkbox.checked;
        if (checkbox == chbox_predator) {
          multi_predator = checkbox.checked;
        } else if (checkbox == chbox_omnivorous) {
          multi_omnivorous = checkbox.checked;
        } else if (checkbox == chbox_classic) {
          mode = checkbox.checked ? MODE.CLASSIC : MODE.NORMAL;
        }
      }
    } else {
      mY -= 30;
      if (0 <= mX && mX <= 810 && 0 <= mY && mY <= 810) {
        // Search living
        boolean found = false;
        Living clickedLiving = null;
        for (Living living:livings) {
          for (Cell cell:living.cells) {
            if (pow(living.x + cell.rx - mX + 5, 2) + pow(living.y + cell.ry - mY + 5, 2) <= 16) {
              clickedLiving = living;
              found = true;
              break;
            }
          }
        }
        detail_pg.beginDraw();
        if (found && clickedLiving != null) {
          detailedLiving = clickedLiving.clone();
          detail_pg.clear();
          for (Cell cell: detailedLiving.cells) {
            detail_pg.fill(0);
            detail_pg.stroke(((cell.gene.gene & 0xc0) / 0x40) *64+63, ((cell.gene.gene & 0x0c) / 0x04) *64+63, ((cell.gene.gene & 0x03) / 0x01) *64+63);
            detail_pg.circle(70+cell.rx, 70+cell.ry, 4);
            detailInfo.update(detailedLiving);
          }
        } else if (5 <= mX && mX <= 805 && 5 <= mY && mY <= 805) {
          detailedLiving = null;
          detail_pg.clear();
          detailInfo.update(detailedLiving);
        }
        detail_pg.endDraw();
      }
    }
  }
  pressedWindow = null;
  releasedWindow = null;
}

void draw() {
  if (game == GAME.LAUNCHER) {
    root.beginDraw();
    root.background(192);
    for (int id:itemids) {
      Window w = items.get(id);
      if (w.packed) {
        w.draw();
      }
    }
    root.endDraw();
    image(root, 0, 0);
  } else if (game == GAME.GENES) {
    draw_genes();
  } else if (game == GAME.PVSZ) {
    draw_pvsz();
  }
}

void draw_genes() {
  root.beginDraw();
  root.background(192);
  root.stroke(0);
  root.fill(128);
  root.rect(810, 5, 150, 245);
  root.rect(810, 255, 150, 550);
  root.fill(0);
  root.rect(815, 300, 140, 140);
  menubar.beginDraw();
  for (int id:itemids) {
    Window w = items.get(id);
    if (w.packed) {
      w.draw();
    }
  }
  menubar.endDraw();
  if (!stoped || just_draw) {
    just_draw = false;
    field_pg.beginDraw();
    field_pg.background(192);
    field_pg.fill(0, 0, 0);
    field_pg.rect(5, 5, 800, 800);
    field_pg.stroke(0, 255, 0);
    int i;
    for (i=0; i<11; i++) {
      field_pg.line(5, 5+i*80, 805, 5+i*80);
      field_pg.line(5+i*80, 5, 5+i*80, 805);
    }
    if (!stoped) {
      calc_genes();
    }
    for (Food food: foods) {
      //field_pg.fill(0, 0, 255);
      field_pg.stroke(0, 0, 255);
      //field_pg.circle(5+food.x, 5+food.y, 1);
      field_pg.point(5+food.x, 5+food.y);
    }
    for (Living living: livings) {
      for (Cell cell: living.cells) {
        field_pg.fill(living.feel == 1 ? #ff0066 : (living.feel == 2 ? #0066ff : #000000));
        field_pg.stroke(((cell.gene.gene & 0xc0) / 0x40) *64+63, ((cell.gene.gene & 0x0c) / 0x04) *64+63, ((cell.gene.gene & 0x03) / 0x01) *64+63);
        field_pg.circle((living.x+cell.rx+800)%800+5, (living.y+cell.ry+800)%800+5, 4);
      }
    }
    field_pg.endDraw();
    plives.updateText(str(livings.size()));
    pfoods.updateText(str(foods.size()));
  }
  root.image(field_pg, 0, 0);
  root.image(detail_pg, 815, 300);
  root.endDraw();
  image(menubar, 0, 0);
  image(root, 0, 30);
}

void calc_genes() {
  // prepare smell map
  for (int i=0; i < 800; i++) {
    for (int k=0; k < 800; k++) {
      smellMap[i][k][0] = smellMap[i][k][1] = smellMap[i][k][2] = smellMap[i][k][3] = 0;
    }
  }
  // create smell map
  for (Living living: livings) {
    for (Cell cell: living.cells) {
      // fixed value: smell origin's strength = 16;
      for (int i = -23; i < 24; i++) {
        for (int k = -23; k < 24; k++) {
          for (int m = 0; m < 4; m++) {
            if ((cell.gene.gene & (1 << (m+8))) > 0) {
              int strength = round(24 - sqrt(pow(abs(i), 2) + pow(abs(k), 2)));
              if (strength > 0) {
                smellMap[(living.y + cell.ry + i + 800) % 800][(living.x + cell.rx + k + 800) % 800][m] += strength;
              }
            }
          }
        }
      }
    }
  }
  //println(smellMap);
  if (foods.size() < food_max) { // food_amount < food_max) {
    boolean duplicate;
    do {
      duplicate = false;
      int [] place = {floor(random(800)), floor(random(800))};
      for (Food food: foods) {
        if (food.x == place[0] && food.y == place[1]) {
          duplicate = true;
          break;
        }
      }
      if (!duplicate) {
        foods.add(new Food(place[0], place[1]));
      }
    } while (duplicate);
  } else if (foods.size() > 0) {
    boolean duplicate;
    Food food = foods.get(floor(random(foods.size())));
    do {
      duplicate = false;
      int [] place = {floor(random(800)), floor(random(800))};
      for (Food othfood: foods) {
        if (food != othfood && othfood.x == place[0] && othfood.y == place[1]) {
          duplicate = true;
          break;
        }
      }
      if (!duplicate) {
        food.x = place[0];
        food.y = place[1];
      }
    } while (duplicate);
  }
  // Move & Give birth to new livings
  ArrayList<Living> newlives = new ArrayList<Living>();
  for (Living living: livings) {
    // Move
    int loveSmell = -1;
    int hateSmell = -1;
    int smellMove = 0;
    for (Cell cell: living.cells) {
      if (loveSmell > 0 || hateSmell > 0) {
        break;
      }
      if ((cell.gene.gene & 0x30000) > 0) {
        if (random(100) > pow(1 - ((cell.gene.gene & 0x30000) >> 16) * 0.02, smellMap[(living.y + cell.ry + 800) % 800][(living.x + cell.rx + 800) % 800][(cell.gene.gene & 0x3000) >> 12]) * 100) {
          // loves the smell
          int count = 0;
          int maxStrength = 0;
          for (int i = 0; i < 4; i++) {
            int sm = smellMap[(living.y + cell.ry + (i == 2 ? -1 : (i == 3 ? 1 : 0)) + 800) % 800][(living.x + cell.rx + (i == 0 ? -1 : (i == 1 ? 1 : 0)) + 800) % 800][(cell.gene.gene & 0x3000) >> 12];
            if (sm > maxStrength) {
              count = 1;
              maxStrength = sm;
            } else if (sm == maxStrength) {
              count++;
            }
          }
          living.feel = 1;
          if (count == 4) {
            println("same str", maxStrength);
            // same strength, cannot decide
          } else {
            loveSmell = smellMap[(living.y + cell.ry + 800) % 800][(living.x + cell.rx + 800) % 800][(cell.gene.gene & 0x3000) >> 12];
            int dirTmp = floor(random(count)); // to select direction randomly
            for (int i = 0; i < 4; i++) {
              if (smellMap[(living.y + cell.ry + (i == 2 ? -1 : (i == 3 ? 1 : 0)) + 800) % 800][(living.x + cell.rx + (i == 0 ? -1 : (i == 1 ? 1 : 0)) + 800) % 800][(cell.gene.gene & 0x3000) >> 12] == maxStrength) {
                if (dirTmp == 0) {
                  smellMove = i;
                  break;
                } else {
                  dirTmp--;
                }
              }
            }
          }
        }
        if (random(100) > pow(1 - ((cell.gene.gene & 0x30000) >> 16) * 0.02, smellMap[(living.y + cell.ry + 800) % 800][(living.x + cell.rx + 800) % 800][(cell.gene.gene & 0xC000) >> 14]) * 100) {
          // hates the smell
          int count = 0;
          int minStrength = -1;
          for (int i = 0; i < 4; i++) {
            int sm = smellMap[(living.y + cell.ry + (i == 2 ? -1 : (i == 3 ? 1 : 0)) + 800) % 800][(living.x + cell.rx + (i == 0 ? -1 : (i == 1 ? 1 : 0)) + 800) % 800][(cell.gene.gene & 0xC000) >> 14];
            if (sm < minStrength || minStrength < 0) {
              count = 1;
              minStrength = sm;
            } else if (sm == minStrength) {
              count++;
            }
          }
          if (count == 4) {
            // same strength, cannot decide
          } else {
            hateSmell = smellMap[(living.y + cell.ry + 800) % 800][(living.x + cell.rx + 800) % 800][(cell.gene.gene & 0xc000) >> 14];
            if (loveSmell <= 0 || random(loveSmell + hateSmell) >= loveSmell) {
              // love v.s. hate
              // hate is the winner
              living.feel = 2;
              int dirTmp = floor(random(count)); // to select direction randomly
              for (int i = 0; i < 4; i++) {
                if (smellMap[(living.y + cell.ry + (i == 2 ? -1 : (i == 3 ? 1 : 0)) + 800) % 800][(living.x + cell.rx + (i == 0 ? -1 : (i == 1 ? 1 : 0)) + 800) % 800][(cell.gene.gene & 0xC000) >> 14] == minStrength) {
                  if (dirTmp == 0) {
                    smellMove = i;
                    break;
                  } else {
                    dirTmp--;
                  }
                }
              }
            } else {
              hateSmell = -1;
            }
          }
        }
      }
    }
    int kx, ky, px, py;
    int prcnt = living.cells.get(0).gene.gene & 0x03;
    int to = (living.cells.get(0).gene.gene & 0x0c) >> 2;
    if (floor(random(4+prcnt)) >= 4) {
      if (loveSmell > 0 || hateSmell > 0) {
        println(loveSmell > 0 ? "love" : "", hateSmell > 0 ? "hate" : "");
        px = 0-int(smellMove == 0)+int(smellMove == 1);
        py = 0-int(smellMove == 2)+int(smellMove == 3);
        if (living.feel == 2) {
          living.energy--;
        }
      } else {
        living.feel = 0;
        px = 0-int(to == 0)+int(to == 1);
        py = 0-int(to == 2)+int(to == 3);
      }
    } else {
      living.feel = 0;
      int movedir = floor(random(4));
      px = -int(movedir == 0)+int(movedir == 1);
      py = -int(movedir == 2)+int(movedir == 3);
    }
    kx = living.x + px;
    ky = living.y + py;
    kx += int(kx < 0) * 800 - int(kx > 800) * 800;
    ky += int(ky < 0) * 800 - int(ky > 800) * 800;
    living.x = kx;
    living.y = ky;
    living.energy -= living.cells.size();
    
    // Give birth
    int cellnum = living.cells.size();
    int dna = living.cells.get(cellnum-1).gene.gene;
    int cdv = ((dna & 0x30) >> 4)+1;
    if (living.energy > (0x1000*cdv*cellnum) && livings.size() + newlives.size() < 4096) {
      int newid = 0;
      Living newlive;
      do {
        newid = floor(random(4096)) + 1;
      } while (livingIds.hasValue(newid));
      if (floor(random(mutation_percent+1)) == 0) {
        if (mode == MODE.NORMAL) {
          int newdna = dna ^ (1 << floor((random(2 + cellnum * 1.5) < cellnum ? random(8) : random(18))));
          if (floor(random(6)) == 0) {
            int nx, ny;
            int connect_dir = (dna & 0xC0) >> 6;
            nx = living.cells.get(cellnum-1).rx + int(connect_dir == 0)*(-4) + int(connect_dir == 1) *4;
            ny = living.cells.get(cellnum-1).ry + int(connect_dir == 2)*(-4) + int(connect_dir == 3) *4;
            newlive = living.clone();
            newlive.cells.add(Cell.fromInt(newdna, nx, ny));
          } else {
            newlive = living.clone();
            newlive.cells.get(0).gene = Gene.fromInt(newdna);
          }
        } else {
          int newcellnum = floor(random(cellnum + 1));
          int newdna = dna ^ (1 << floor((random(2 + cellnum * 1.5) < cellnum ? random(8) : random(18)))); // floor(random(0x40000));
          newlive = living.clone();
          if (newcellnum == cellnum) {
            int nx, ny;
            int connect_dir = (dna & 0xC0) >> 6;
            nx = living.cells.get(cellnum-1).rx + int(connect_dir == 0)*(-4) + int(connect_dir == 1) *4;
            ny = living.cells.get(cellnum-1).ry + int(connect_dir == 2)*(-4) + int(connect_dir == 3) *4;
            newlive.cells.add(Cell.fromInt(newdna, nx, ny));
            cellnum++;
          } else {
            newlive.cells.get(newcellnum).gene.gene = newdna;
          }
          if (newdna == 0) {
            for(int k = cellnum - 1; k > newcellnum; k--) {
              newlive.cells.remove(k);
            }
          }
        }
      } else {
        newlive = living.clone();
      }
      living.energy /= 2;
      newlive.energy /= 2;
      newlive.id = newid;
      newlives.add(newlive);
      livingIds.append(newid);
    }
  }
  for (Living living: newlives) {
    livings.add(living);
  }
  
  // Eat and Die
  //int botsu = 0; // name from what? (たしか「没」だけど、なんでだっけ、中2の自分よ) (今回は使う必要なし、食べられた餌の数用の一時変数だったわそういや)
  ArrayList<Living> deadLivings = new ArrayList<Living>();
  ArrayList<Food> eatenFoods = new ArrayList<Food>();
  for (Living living: livings) {
    if (deadLivings.contains(living)) {
      continue;
    }
    for (Cell cell: living.cells) {
      if (living.cells.size() == 1 || multi_omnivorous) {
        for (Food food: foods) {
          if (eatenFoods.contains(food)) {
            continue;
          }
          if (abs((food.x - (living.x + cell.rx) + 800) % 800 - 400) >= 397 && abs((food.y - (living.y + cell.ry) + 800) % 800 - 400) >= 397) {
            living.energy += 0x500;
            eatenFoods.add(food);
          }
        }
      }
      if (living.cells.size() > 1 && multi_predator && !deadLivings.contains(living)) {
        for (Living victim: livings) {
          if (victim == living || victim.cells.size() >= living.cells.size() || deadLivings.contains(victim)) {
            continue;
          }
          for (Cell victimCell: victim.cells) {
            if (abs((victim.x + victimCell.rx - (living.x + cell.rx) + 800) % 800 - 400) >= 397 && abs((victim.y + victimCell.ry - (living.y + cell.ry) + 800) % 800 - 400) >= 397) {
              living.energy += max(0, victim.energy);
              victim.energy = 0;
              deadLivings.add(victim);
              break;
            }
          }
        }
      }
    }
    if (living.energy <= 0) {
      deadLivings.add(living);
    } 
  }
  for (Living victim: deadLivings) {
    livings.remove(victim);
    for (int i=0; i < livingIds.size(); i++) {
      if (livingIds.get(i) == victim.id) {
        livingIds.remove(i);
        break;
      }
    }
  }
  for (Food food: eatenFoods) {
    foods.remove(food);
  }
}

boolean loadSave(File file) {
  if (file == null) {
    return false;
  }
  String data = join(loadStrings(file.getAbsolutePath()), "\n");
  String version = splitTokens(split(data, "#")[0], "'")[0];
  if (match(version, "^1[.]0[.]0$") == null) {
    print("Only version 1.0.0 savedata is acceptable, but given was "+version);
    return false;
  }

  // clear current data
  livings.clear();
  livingIds.clear();
  foods.clear();
  detailedLiving = null;

  String[] datas = split(data, "%");

  // metadata
  for (int i = 0; i < split(datas[0], "#").length; i++) {
    switch (i) {
      case 1:
        break;
      case 4:
        fdmaxscl.set(int(split(datas[0], "#")[4]));
        food_max = fdmaxscl.get();
        fdmaxscl.text = "FoodMAX: " + str(food_max);
        break;
      case 5:
        mutationscl.set(int(split(datas[0], "#")[5]));
        mutation_percent = mutationscl.get();
        mutationscl.text = "Mutation(1/n): " + str(mutation_percent);
        break;
      case 6:
        multi_predator = match(split(datas[0], "#")[6], "^False$") != null ? false : true;
        chbox_predator.checked = multi_predator;
        break;
      case 7:
        multi_omnivorous = match(split(datas[0], "#")[7], "^False$") != null ? false : true;
        chbox_omnivorous.checked = multi_omnivorous;
        break;
      default:
        break;   
    }
  }

  // living data
  for (String livingData: split(datas[1], "#")) {
    ArrayList<Cell> cells = new ArrayList<Cell>();
    int [] origin = {int(splitTokens(livingData, ":[, ]")[3]), int(splitTokens(livingData, ":[, ]")[4])};
    for (int i = 0; i < int(splitTokens(livingData, ":[, ]")[1]); i++) {
      String[] tmp = subset(splitTokens(livingData, ":[, ]"), 3+i*4, 3);
      Cell cell = Cell.fromInt(int(tmp[2]), int(tmp[0]) - origin[0], int(tmp[1]) - origin[1]);
      cells.add(cell);
    }
    Living living = new Living(int(splitTokens(livingData, ":[, ]")[0]), origin[0], origin[1], int(splitTokens(livingData, ":[, ]")[2]), cells);
    livings.add(living);
    livingIds.append(living.id);
  }

  // food data
  for (String foodData: split(datas[2], "#")) {
    Food food = new Food(int(splitTokens(foodData, "[, ]")[0]), int(splitTokens(foodData, "[, ]")[1]));
    foods.add(food);
  }

  initial_draw = true;
  just_draw = true;
  return true;
}

boolean writeSave(File file) {
  if (file == null) {
    return false;
  }

  String[] livingDatas = new String[livings.size()];
  for (int i = 0; i < livings.size(); i++) {
    Living living = livings.get(i);
    String[] cellDatas = new String[living.cells.size()];
    for (int k = 0; k < living.cells.size(); k++) {
      Cell cell = living.cells.get(k);
      cellDatas[k] = join(new String[] {
        str(living.x + cell.rx),
        str(living.y + cell.ry),
        str(cell.gene.gene),
        "0"
      }, ", ");
    }
    livingDatas[i] = join(new String[] {
      str(living.id) + ":[" + str(living.cells.size()),
      str(living.energy),
      join(cellDatas, ", ")
    }, ", ") + "]";
  }

  String[] foodDatas = new String[foods.size()];
  for (int i = 0; i < foods.size(); i++) {
    Food food = foods.get(i);
    foodDatas[i] = "[" + join(new String[] {
      str(food.x),
      str(food.y),
    }, ", ") + "]";
  }

  String data = join(new String[]{
    join(new String[] {
      "'1.0.0'",
      "0",
      str(livings.size()),
      str(foods.size()),
      str(food_max),
      str(mutation_percent),
      multi_predator ? "True" : "False",
      multi_omnivorous ? "True" : "False"
    }, "#"),
    join(livingDatas, "#"), // livings
    join(foodDatas, "#") // foods
  }, "%"); // + "#"; // originally, but this is unnecessary

  saveStrings(file.getAbsolutePath(), new String[] {data});

  return true;
}

void draw_pvsz() {
  IntList drawn = new IntList();
  root.beginDraw();
  root.background(192);
  root.stroke(0);
  root.fill(128);
  root.rect(810, 5, 150, 245);
  root.rect(810, 255, 150, 550);
  root.fill(0);
  root.rect(815, 300, 140, 140);
  moneyLabel.text = str(money);
  root.image(assets[0][0], 0, 0, 640, 384);
  for (int k = 0; k < 5; k++) {
    for (Friend friend: friends) {
      if (friend.position[1] == k && friend.label.packed) {
        friend.label.draw();
        drawn.append(friend.label.id);
      }
    }
    for (Enemy enemy: enemies) {
      if (round(enemy.position[1]) == k && enemy.label.packed) {
        enemy.label.draw();
        drawn.append(enemy.label.id);
      }
    }
  }
  if (dragging) {
    root.fill(color(255, 0, 0, 0));
    root.strokeWeight(1);
    root.stroke(#000000);
    for (int k = 0; k < 5; k++) {
      for (int l = 0; l < 8; l++) {
        root.rect(64 * l + 64, 64 * k + 64, 64, 64);
      }
    }
    if (64 <= mouseX && 64*8 + 64 > mouseX && 64 <= mouseY && 64*8 + 128 > mouseY) {
      root.strokeWeight(8);
      root.stroke(#ff0000);
      root.rect(64 * floor(mouseX / 64.0), 64 * floor(mouseY / 64.0), 64, 64);
    }
  }
  root.strokeWeight(1);
  root.fill(#222222);
  root.stroke(#000000);
  root.rect(-8, 64*cannon_position+72, 64, 48);
  root.fill(#444444);
  root.rect(32, 64*cannon_position+80, 8, 32);
  root.fill(#ff0000);
  root.rect(32, 64*cannon_position+80 + 32 * ((float)cooldowns[0][0] / (float)cooldowns[0][1]), 8, 32 * (1 - (float)cooldowns[0][0] / (float)cooldowns[0][1]));
  // show HP
  root.fill(#666666);
  root.rect(2, 362, 480, 16);
  root.fill(#ff2266);
  root.rect(2 + 480*(1 - heart / 10000.0), 362, 480 * (heart / 10000.0), 16);
  for (int id:itemids) {
    Window w = items.get(id);
    if (!drawn.hasValue(w.id) && w.packed) {
      w.draw();
    }
  }
  drawn.clear();
  if (heart <= 0) {
    root.endDraw();
    image(root, 0, 0);
    return;
  }
  if (cooldowns[0][0] > 0) {
    cooldowns[0][0]--;
  }
  int i = 1;
  for (Button btn: generators) {
    if (btn == null) {
      break;
    }
    if (cooldowns[i][0] > 0) {
      cooldowns[i][0]--;
    }
    int cost = getCost(i);
    if (cost < 0 || cost > money || cooldowns[i][0] > 0) {
      btn.status = STATUS.DISABLED;
    } else {
      btn.status = STATUS.NORMAL;
    }
    if (cooldowns[i][0] > 0) {
      root.fill(color(0, 0, 0, 160));
      root.stroke(color(255, 0, 0, 0));
      root.rect(btn.x, btn.y + btn.height * (1 - (float)cooldowns[i][0] / (float)cooldowns[i][1]), btn.width, btn.height * ((float)cooldowns[i][0] / (float)cooldowns[i][1]));
    }
    i++;
  }

  for (int k = 0; k < suns.size();) {
    Sun sun = suns.get(k);
    sun.position[1] += sun.speed / 60;
    sun.label.y = round(sun.position[1] * 64 + 96  - sun.label.width / 2);
    if (sun.position[1] > 6) {
      sun.label.destroy();
      suns.remove(sun);
    } else {
      k++;
    }
  }
  for (int k = 0; k < bullets.size();) {
    Bullet bullet = bullets.get(k);
    float distance = random(0.10, 0.15);
    for (Enemy enemy: enemies) {
      if (abs(round(bullet.position[1]) - round(enemy.position[1])) < enemy.size / 2.0) {
        if (enemy.position[0] > bullet.position[0] && enemy.position[0] <= bullet.position[0] + distance + enemy.speed / 60) {
          // bang!
          enemy.damage(bullet.damage);
          if (bullet.freeze) {
            enemy.freeze();
          }
          bullet.label.destroy();
          bullets.remove(bullet);
          break;
        }
      }
    }
    if (bullets.contains(bullet)) {
      bullet.position[0] += distance;
      bullet.label.x = round(bullet.position[0] * 64 + 64  - bullet.label.width / 2);
      if (bullet.position[0] > 12) {
        bullet.label.destroy();
        bullets.remove(bullet);
      } else {
        k++;
      }
    }
  }
  for (int n=0; n < friends.size();) {
    Friend friend = friends.get(n);
    boolean attacked = false;
    for (int k = 0; k < enemies.size();) {
      Enemy enemy = enemies.get(k);
      if (abs(friend.position[1] - round(enemy.position[1])) < enemy.size / 2.0 && abs(friend.position[0] - enemy.position[0]) < 1.0) {
        if (friend.type != 4 || friend.interval <= 0) {
          enemy.damage(friend.attack / 10);
          attacked = true;
          if (friend.type != 4) {
            break;
          }
        }
      }
      k++;
    }
    if (friend.interval > 0) {
      friend.interval--;
    }
    if (friend.interval <= 0) {
      if (friend.type == 2) {
        float position[] = new float[]{
          friend.position[0] - 0.25,
          friend.position[1] + 0.25
        };
        Label label = new Label(root, assets[0][1]);
        label.bg = color(255, 0, 0, 0);
        label.pack(round(position[0]*64+96), round(position[1]*64+96), ANCHOR.CENTER);
        suns.add(new Sun(label, 25, position, 0.0));
      } else if (friend.type == 4) {
        // BOM!
        for (int k = 0; k < enemies.size();) {
          Enemy enemy = enemies.get(k);
          if (pow(friend.position[1] - enemy.position[1], 2) + pow(friend.position[0] - enemy.position[0], 2) < 3.5 + enemy.size / 2.0) {
            attacked = true;
            enemy.damage(200.0);
            if (enemy.heart > 0) {
              k++;
            }
          } else {
            k++;
          }
        }
        friend.heart = -1;
        friend.damage(1);
      } else if (friend.type == 5) {
        // enemies around?
        boolean triggered = false;
        for (Enemy enemy: enemies) {
          if (pow(friend.position[1] - enemy.position[1], 2) + pow(friend.position[0] - enemy.position[0], 2) < enemy.size / 2.0) {
            triggered = true;
            break;
          }
        }
        if (triggered) {
          attacked = true;
          for (int k = 0; k < enemies.size();) {
            Enemy enemy = enemies.get(k);
            if (abs(friend.position[1] - round(enemy.position[1])) < enemy.size / 2.0 && pow(friend.position[0] - enemy.position[0], 2) < 3.5) {
              attacked = true;
              enemy.damage(200.0);
              if (enemy.heart > 0) {
                k++;
              }
            } else {
              k++;
            }
          }
          friend.heart = -1;
          friend.damage(1);
        }
      } else if (!attacked && friend.bullet > 0) {
        // fire!
        Label label = new Label(root, createImage(16, 16, ARGB));
        for (int k = 0; k < label.image.pixels.length; k++) {
          label.image.pixels[k] = color(0, 102, (friend.type == 6 ? 255 : 102), 15*(k % label.image.width));
        }
        Bullet bullet = new Bullet(label, new float[]{float(friend.position[0]) + 0.5, float(friend.position[1])}, friend.bullet, friend.type == 6);
        bullets.add(bullet);
        label.pack(friend.position[0] * 64 + 96, friend.position[1] * 64 + 96, ANCHOR.CENTER);
      }
      if (friend.type == 1) {
        friend.interval = 60;
      } else if (friend.type == 2) {
        friend.interval = 800;
      } else if (friend.type == 6) {
        friend.interval = 120;
      } else if (friend.type != 5) {
        friend.interval = 100;
      }
    }
    if (friend.type == 4) {
      root.fill(color(255, 0, 0, max(0, 24 - friend.interval)));
      root.stroke(color(255, 0, 0, max(0, 24 - friend.interval) * 255 / 24));
      root.circle(friend.position[0]*64+96, friend.position[1]*64+96, sqrt(6)*64+32);
    }
    if (friend.type == 5 && friend.interval <= 0) {
      root.fill(color(255, 128, 0, 16));
      root.stroke(color(255, 128, 0));
      root.circle(friend.position[0]*64+96, friend.position[1]*64+96, sqrt(1)*56);
      root.fill(color(255, 0, 0, 0));
      root.ellipse(friend.position[0]*64+96, friend.position[1]*64+96, sqrt(6)*64+32, sqrt(1)*64);
    }
    n++;
  }
  for (Enemy enemy: enemies) {
    if (enemy.freezed > 0) {
      enemy.melt();
    }
    boolean attacked = false;
    for (int k = 0; k < friends.size();) {
      Friend friend = friends.get(k);
      if (friend.position[1] == round(enemy.position[1]) && abs(friend.position[0] - enemy.position[0]) < 1.0 && friend.guard < 10000) {
        println(enemy.attack / 10);
        friend.damage(enemy.attack / 10);
        attacked = true;
        break;
      }
      k++;
    }
    if (!attacked) {
      if (enemy.position[0] <= -0.5) {
        // attack the player
        heart = max(0.0, heart - enemy.attack / 10);
      } else {
        float delta = (enemy.freezed <= 0 ? enemy.speed / 60 : enemy.speed / 180);
        enemy.position[0] = max(-0.5, enemy.position[0] - delta);
        enemy.label.x = round(enemy.position[0] * 64 + 64);
      }
    }
  }
  if (exp >= 10 * pow(1.5, level)) {
    level++;
    if (level > 0 && level % 10 == 0) {
      // level boss
      enemies.add(createEnemy(5, new int[]{9, 2}));
    }
    exp = 0;
    levelLabel.text = str(level);
  }
  expLabel.text = str(exp);
  switch (level) {
    case 1:
      if (enemies.size() < 1 && random(0, 300) < 1) {
        enemies.add(createEnemy(1, new int[]{9, floor(random(0, 5))}));
      }
      break;
    case 2:
      if (enemies.size() < 5 && random(0, 300) < 2) {
        enemies.add(createEnemy(1, new int[]{9, floor(random(0, 5))}));
      }
      break;
    case 3:
      if (random(0, 300) < 2) {
        enemies.add(createEnemy(1, new int[]{9, floor(random(0, 5))}));
      } else if (random(0, 1200) < 3) {
        enemies.add(createEnemy(2, new int[]{9, floor(random(0, 5))}));
      }
      break;
    case 4:
    case 5:
      if (random(0, 300) < 2) {
        enemies.add(createEnemy(1, new int[]{9, floor(random(0, 5))}));
      } else if (random(0, 1200) < 3) {
        enemies.add(createEnemy(2, new int[]{9, floor(random(0, 5))}));
      } else if (random(0, 1200) < 5) {
        enemies.add(createEnemy(3, new int[]{9, floor(random(0, 5))}));
      }
      break;
    case 6:
      if (random(0, 300) < 2) {
        enemies.add(createEnemy(1, new int[]{9, floor(random(0, 5))}));
      } else if (random(0, 1200) < 3) {
        enemies.add(createEnemy(2, new int[]{9, floor(random(0, 5))}));
      } else if (random(0, 1200) < 5) {
        enemies.add(createEnemy(3, new int[]{9, floor(random(0, 5))}));
      } else if (random(0, 1200) < 2) {
        enemies.add(createEnemy(4, new int[]{9, floor(random(0, 5))}));
      }
      break;
    default:
      if (enemies.size() < level * 3 && random(0, 300) < 2) {
        enemies.add(createEnemy(floor(random(4))+1, new int[]{9, 1+floor(random(0, 4))}));
      }
      break;
  }
  moneyInterval--;
  if (moneyInterval <= 0) {
    float position[] = new float[]{
      random(3, 5),
      -0.5
    };
    Label label = new Label(root, assets[0][1]);
    label.bg = color(255, 0, 0, 0);
    label.pack(round(position[0]*64+96), round(position[1]*64+96), ANCHOR.CENTER);
    suns.add(new Sun(label, 25, position, 1.0));
    moneyInterval = 650 + round(random(100));
  }
  if (heart <= 0) {
    new Label(root, 16, 8, "Game Over!").pack(320, 192, ANCHOR.CENTER);
  }
  root.endDraw();
  image(root, 0, 0);
}
