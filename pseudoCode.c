int K; // kernel width
int R; // output ROWS
int C; // output COLUMNS
int M; // num of output layers
int N; // num of input layers
// for purposes of midterm demo, just focus on the unrolling
// use shortreal

for ( i=0; i<K; i++ ) {
    for ( j=0; j<K; j++) {
        for (trr=row; trr<min(row+Tr,R); trr++) {
            for (tcc=col; tcc<min(col+Tc,C); tcc++) {
                // PIPELINE 
                for (too=to; too<min(to+Tm, M); too++) {
                    // UNROLL in parallel
                    for (tii=ti; tii<min(ti+Tn, N); tii++) {
                        // UNROLL in parallel
                        output_fm[too][trr][tcc] +=
                            weights[too][tii][i][j]*
                            input_fm[tii][S*trr+i][S*tcc+j];
                    }
                }
            }
        }
    }
}