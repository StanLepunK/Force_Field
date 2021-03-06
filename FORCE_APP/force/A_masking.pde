/**
MASK MAPPING
v 0.1.0
*/
boolean border_is;
boolean default_mask_is = true;
void mask_mapping(boolean change_is) {
  // use border mask
  mask_mapping(change_is,0,0,0);
}
/**
master method
*/
void mask_mapping(boolean change_is, int type_mask, int num_mask, int num_point_mask) {
  // P3D
  if(get_renderer() == P3D) {
    push();
    translateZ(1);
  }

  if(type_mask == 0) {
      border_is = true ;
    if(border_is) {
      if(display_mask_is(0)) {
        mask_mapping_border(change_is, default_mask_is);
      }
    }
  } else {
    mask_mapping_blocks(change_is, num_mask, num_point_mask);  
  } 

  // P3D
  if(get_renderer() == P3D) {
    pop();
  }
}



/**
block mask
*/
Masking [] masks;
Coord_mapping [] coord_mask;
void mask_mapping_blocks(boolean change_is, int num, int num_point_mask) {
  if(masks == null) {
    coord_mask = new Coord_mapping[num];
    masks = new Masking[coord_mask.length];
    
    data_mask_mapping_blocks(coord_mask, num_point_mask);
    for(int i = 0 ; i < num ; i++) {
      masks[i] = new Masking(coord_mask[i].get());
    }
  } else {
    if(display_mask_is(0)) {
      for(int i = 0 ; i < num ;i++) {
        if(display_mask_is(i+1)) {
          masks[i].draw(change_is);
        }
      }
    }    
  }
}

// blocks

void data_mask_mapping_blocks(Coord_mapping [] coord, int num_points_by_mask) {
  int marge = 100;

  for(int i = 0 ; i < coord.length ; i++) {
    ivec2 [] coord_mask = new ivec2[num_points_by_mask];
    ivec2 p = ivec2((int)random(marge,width-marge),(int)random(marge,height-marge));
    for(int k = 0 ; k < coord_mask.length ; k++) {
      int range = marge/2 ;
      coord_mask[k] = ivec2(p.x + int(random(-range,range)),p.y + int(random(-range,range)));
    }
    coord[i] = new Coord_mapping(coord_mask);
  }
}

class Coord_mapping {
  ivec2 [] coord;
  Coord_mapping(ivec2 [] coord_pos) {
    this.coord = new ivec2[coord_pos.length];
    for(int i = 0 ; i < this.coord.length ;i++) {
      this.coord[i]= ivec2(coord_pos[i]);
    }
  }

  ivec2 [] get() {
    return coord;
  }

  void set(int i,int x, int y) {
    if(coord[i] != null) {
      coord[i].set(x,y);
    } else {
      coord[i] = ivec2(x,y);
    }
  }
}


/**
border mask
*/
Masking mask_border;
boolean init_mask_is;
void mask_mapping_border(boolean change_is, boolean default_mask_is) {
  // build mask
  if(!init_mask_is) {
    if(mask_border == null || default_mask_is) {
      mask_mapping_border_default();
      mask_border = new Masking(coord_connected,coord_block_1,coord_block_2,coord_block_3,coord_block_4);
      init_mask_is = true;
    } else if(mask_loaded_is) {
      mask_border = new Masking(coord_connected,coord_block_1,coord_block_2,coord_block_3,coord_block_4);
      mask_loaded_is = false;
      init_mask_is = true;
    }
  }
   
  // draw mask
  if(mask_border != null && init_mask_is) {
    if(display_mask_is(0)) {
      mask_border.draw(change_is);
    }
    if(change_is) {
      coord_connected = mask_border.get_coord();
      coord_block_1 = mask_border.get_coord_block_1();
      coord_block_2 = mask_border.get_coord_block_2();
      coord_block_3 = mask_border.get_coord_block_3();
      coord_block_4 = mask_border.get_coord_block_4();
      //write_file_mask_mapping(get_file_mask_mapping());
      write_file_mask_mapping();
      save_file_mask_mapping(get_file_mask_mapping(),sketchPath(1)+ "/save/last_border_mask.csv");
    }
  }  
}

ivec2 [] coord_connected;
ivec2 [] coord_block_1,coord_block_2,coord_block_3,coord_block_4;
void mask_mapping_border_default() {
  int marge = 40;
  coord_connected = new ivec2 [8];
  // outside
  coord_connected[0] = ivec2(0,0);
  coord_connected[1] = ivec2(width,0);
  coord_connected[2] = ivec2(width,height);
  coord_connected[3] = ivec2(0,height);
  // inside
  coord_connected[4] = ivec2(marge,marge);
  coord_connected[5] = ivec2(width-marge,marge);
  coord_connected[6] = ivec2(width-marge,height-marge);
  coord_connected[7] = ivec2(marge,height-marge);
  
  // coord_block_1
  coord_block_1 = new ivec2 [2];
  coord_block_1[0] = ivec2(width -width/3,marge);
  coord_block_1[1] = ivec2(width/3,marge);

  // coord_block_2
  coord_block_2 = new ivec2 [0];

  // coord_block_3
  coord_block_3 = new ivec2 [2];
  coord_block_3[0] = ivec2(width/3,height-marge);
  coord_block_3[1] = ivec2(width-width/3,height-marge);

  // coord_block_4
  coord_block_4 = new ivec2 [0];
}



/**
block mask
*/
/*
Mapping [] masks;
void mask_mapping_2_blocks(boolean change_is) {
  if(masks == null) {
    data_mask_mapping_blocks();
    masks = new Mapping[num_mask_mapping];
    masks[0] = new Mapping(coord_mask_0);
    masks[1] = new Mapping(coord_mask_1);
  } else {
    masks[0].draw(change_is);
    masks[1].draw(change_is);
  }
}

// blocks
ivec2 [] coord_mask_0, coord_mask_1;
int num_mask_mapping;
void data_mask_mapping_blocks() {
  int marge = 40;
  coord_mask_0 = new ivec2[4];
  coord_mask_0[0] = ivec2(0,0);
  coord_mask_0[1] = ivec2(width,0);
  coord_mask_0[2] = ivec2(width,marge);
  coord_mask_0[3] = ivec2(0,marge);

  coord_mask_1 = new ivec2[4];
  coord_mask_1[0] = ivec2(0,height-marge);
  coord_mask_1[1] = ivec2(width,height-marge);
  coord_mask_1[2] = ivec2(width,height);
  coord_mask_1[3] = ivec2(0,height);

  num_mask_mapping = 2;
}
*/











/**
load data save
*/
boolean mask_loaded_is ;
void load_save_mask(File selection) {
  if (selection == null) {
    println("No file has been selected for data mask");
  } else {
    Table t = loadTable(selection.getAbsolutePath(),"header");
    set_file_mask_mapping(t);
    // mask border part
    if(get_file_mask_mapping().getRowCount() > 7) {
      int target = 0;
      for (TableRow row : get_file_mask_mapping().findRows("coord_connected", "name")) {
        int x = row.getInt("x");
        int y = row.getInt("y");
        coord_connected[target].set(x,y);
        target++;
      }
      target = 0;
      for (TableRow row : get_file_mask_mapping().findRows("coord_block_1", "name")) {
        int x = row.getInt("x");
        int y = row.getInt("y");
        coord_block_1[target].set(x,y);
        target++ ;
      }
      target = 0;
      for (TableRow row : get_file_mask_mapping().findRows("coord_block_2", "name")) {
        int x = row.getInt("x");
        int y = row.getInt("y");
        coord_block_2[target].set(x,y);
        target++ ;
      }
      target = 0;
      for (TableRow row : get_file_mask_mapping().findRows("coord_block_3", "name")) {
        int x = row.getInt("x");
        int y = row.getInt("y");
        coord_block_3[target].set(x,y);
        target++ ;
      }
      target = 0;
      for (TableRow row : get_file_mask_mapping().findRows("coord_block_4", "name")) {
        int x = row.getInt("x");
        int y = row.getInt("y");
        coord_block_4[target].set(x,y);
        target++ ;
      }
      // mapping block indépendant
      for (TableRow row : get_file_mask_mapping().findRows("Total_mask", "name")) {
        int num = row.getInt("num");
        coord_mask = new Coord_mapping[num];
        break;
      }
      
      // find num
      masks = new Masking[coord_mask.length];
      for(int i = 0 ; i < masks.length ; i++) {
        for (TableRow row : get_file_mask_mapping().findRows("coord_mask_"+i, "name")) {
          int x = row.getInt("x");
          int y = row.getInt("y");
          coord_mask[i].set(target,x,y);
        }

        // data_mask_mapping_blocks(coord_mask, num_point_mask);
        /*
        for(int i = 0 ; i < num ; i++) {
          masks[i] = new Mapping(coord_mask[i].get());
        }
        */
      }

    }
    init_mask_is = false;
    default_mask_is = false;
    mask_loaded_is = true;
    // mask_mapping(false);
  }  
}