#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
                      
#define MAX_LENGTH 1000 
#define MAX_LINE_LENGTH 1024
#define MAX_ROW_NUM 2000


void CUSUM_Anomaly_Detection(const int* x, int length, int* anomaly_counter, int threshold, int drift, int* anomalies) {
    double g_positive = 0.0; 
    double g_nigative = 0.0; 
    *anomaly_counter = 0; 
    
    for (int t = 1 ; t < length ; t++) {
        double st = x[t] - x[t-1];
        g_positive = fmax(g_positive + st - drift, 0);
        g_nigative = fmax(g_nigative - st - drift, 0);

        if (g_positive > threshold || g_nigative > threshold) {
            anomalies[*anomaly_counter] = t;
            (*anomaly_counter)++; 
            g_positive = 0;
            g_nigative = 0;
        }
    }
}

//generated function by chat gpt 
void plot_data(int col1[], int col2[], int col3[], int col4[], int col5[], int col6[], int rows) {
    FILE *temp_file = fopen("plot_data.dat", "w");

    for (int i = 0; i < rows; i++) {
        fprintf(temp_file, "%d %d %d %d %d %d %d\n",
                i+1, col1[i], col2[i], col3[i], col4[i], col5[i], col6[i]);
    }
    fclose(temp_file);

    FILE *gnuplot = popen("gnuplot -persist", "w");
    if (gnuplot == NULL) {
        fprintf(stderr, "Error: Could not open gnuplot\n");
        return;
    }

    fprintf(gnuplot, "set title 'Sensor Data'\n");
    fprintf(gnuplot, "set xlabel 'Time (Index)'\n");
    fprintf(gnuplot, "set ylabel 'Sensor Value'\n");
    fprintf(gnuplot, "set grid\n");

    fprintf(gnuplot, "plot 'plot_data.dat' using 1:2 with lines title 'col1', \\\n");
    fprintf(gnuplot, "     '' using 1:3 with lines title 'col2', \\\n");
    fprintf(gnuplot, "     '' using 1:4 with lines title 'col3', \\\n");
    fprintf(gnuplot, "     '' using 1:5 with lines title 'col4', \\\n");
    fprintf(gnuplot, "     '' using 1:6 with lines title 'col5', \\\n");
    fprintf(gnuplot, "     '' using 1:7 with lines title 'col6'\n");

    fclose(gnuplot);
}

void test_algo()
{
    int sensore_data[MAX_LENGTH] = {10, 12, 15, 14, 30, 12, 14, 9, 25, 12};
    int length = 10 ;

    int anomalies[MAX_LENGTH]; 
    int anomaly_counter; 

    CUSUM_Anomaly_Detection(sensore_data, length, &anomaly_counter, 10, 1, anomalies);

    printf("Detected anomalies at indices:\n");
    for (int i = 0; i < anomaly_counter; i++) 
    {
        printf("%d ", anomalies[i]);
    }
    printf("\n");

}

int main(int argc, char** argv) {
    if (argc < 4) {
        perror("Too few arguments");
        return -1; 
    }
    char* input_validation; 

    const char *filename = argv[3]; 
    FILE *file = fopen(filename, "r");

    if (file == NULL) {
        perror("Error opening file");
        return 2;
    }

    double threshold = strtod(argv[1], &input_validation);
    if (*input_validation != '\0') {
        printf("Invalid threshold, enter a valid double value\n");
        return -3;
    }
    
    double drift = strtod(argv[2], &input_validation);
    if (*input_validation != '\0') {
        printf("Invalid drift, enter a valid double value\n");
        return -4;
    }

    int col1[MAX_ROW_NUM], col2[MAX_ROW_NUM], col3[MAX_ROW_NUM], col4[MAX_ROW_NUM], col5[MAX_ROW_NUM], col6[MAX_ROW_NUM];
    int row_count = 0;
    char line[MAX_LINE_LENGTH];

    // Skip the header row
    fgets(line, sizeof(line), file);

    while (fgets(line, sizeof(line), file)) {
        if (row_count >= MAX_ROW_NUM) {
            fprintf(stderr, "Exceeded maximum row limit.\n");
            break;
        }

        char *token = strtok(line, ",");
        // Skip the first column 
        token = strtok(NULL, ",");
        
        col1[row_count] = 100 * (int)atof(token); 
        token = strtok(NULL, ",");
        col2[row_count] = 100 * atoi(token); 
        token = strtok(NULL, ",");
        col3[row_count] = 100 * (int)atof(token); 
        token = strtok(NULL, ",");
        col4[row_count] = 100 * (int)atof(token); 
        token = strtok(NULL, ",");
        col5[row_count] = 100 * (int)atof(token); 
        token = strtok(NULL, ",");
        col6[row_count] = 100 * (int)atof(token);

        row_count++;
    }

    fclose(file);

    int anomalies[6][MAX_ROW_NUM]; 
    int anomaly_counter[6]; 
    
    CUSUM_Anomaly_Detection(col1, row_count, &anomaly_counter[0], threshold, drift, anomalies[0]);
    CUSUM_Anomaly_Detection(col2, row_count, &anomaly_counter[1], threshold, drift, anomalies[1]);
    CUSUM_Anomaly_Detection(col3, row_count, &anomaly_counter[2], threshold, drift, anomalies[2]);
    CUSUM_Anomaly_Detection(col4, row_count, &anomaly_counter[3], threshold, drift, anomalies[3]);
    CUSUM_Anomaly_Detection(col5, row_count, &anomaly_counter[4], threshold, drift, anomalies[4]);
    CUSUM_Anomaly_Detection(col6, row_count, &anomaly_counter[5], threshold, drift, anomalies[5]);

    plot_data(col1, col2, col3, col4, col5, col6, row_count);
    test_algo();
    return 0;
}
