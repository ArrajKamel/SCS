import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


def cusum_anomaly_detection(data, threshold, drift):
    """
    Perform Two-Sided CUSUM Anomaly Detection.

    Parameters:
        data (list or np.array): The time-series data.
        threshold (float): The threshold for detecting anomalies.
        drift (float): The drift value for CUSUM.

    Returns:
        anomalies (list): Indices of detected anomalies.
    """
    g_positive = 0.0
    g_negative = 0.0
    anomalies = []

    for t in range(1, len(data)):
        st = data[t] - data[t - 1]
        g_positive = max(g_positive + st - drift, 0)
        g_negative = max(g_negative - st - drift, 0)

        if g_positive > threshold or g_negative > threshold:
            anomalies.append(t)
            g_positive = 0
            g_negative = 0

    return anomalies


def plot_column_data_with_anomalies(df, column_name, anomalies):
    """
    Plot a column of data from a DataFrame with anomalies highlighted.

    Parameters:
        df (pd.DataFrame): The data as a pandas DataFrame.
        column_name (str): The name of the column to plot.
        anomalies (list): Indices of detected anomalies.
    """
    plt.figure(figsize=(12, 6))
    plt.plot(df.index, df[column_name], label=column_name, color="blue")
    plt.scatter(
        df.index[anomalies],
        df[column_name].iloc[anomalies],
        color="red",
        label="Anomalies",
        zorder=5,
    )
    plt.title(f"{column_name} with Anomalies")
    plt.xlabel("Time (Index)")
    plt.ylabel("Sensor Value")
    plt.legend()
    plt.grid(True)
    plt.show()


def main():
    import sys

    if len(sys.argv) < 4:
        print("Usage: python script.py <threshold> <drift> <filename>")
        return

    # Get command-line arguments
    threshold = float(sys.argv[1])
    drift = float(sys.argv[2])
    filename = sys.argv[3]

    # Read CSV into a pandas DataFrame
    df = pd.read_csv(filename)

    # Assuming the data starts from the second column
    df = df.iloc[:, 1:] * 100  # Scale by 100 as in the original code

    # Detect anomalies for each column and plot
    for column in df.columns:
        anomalies = cusum_anomaly_detection(df[column].values, threshold, drift)
        plot_column_data_with_anomalies(df, column, anomalies)

    # Test with synthetic data
    test_data = pd.Series([10, 12, 15, 14, 30, 12, 14, 9, 25, 12])
    anomalies_test = cusum_anomaly_detection(test_data.values, threshold=10, drift=1)
    print("Detected anomalies in test data at indices:", anomalies_test)

    plt.figure(figsize=(12, 6))
    plt.plot(test_data.index, test_data, label="Test Data", color="blue")
    plt.scatter(
        test_data.index[anomalies_test],
        test_data.iloc[anomalies_test],
        color="red",
        label="Anomalies",
        zorder=5,
    )
    plt.title("Test Data with Anomalies")
    plt.xlabel("Time (Index)")
    plt.ylabel("Sensor Value")
    plt.legend()
    plt.grid(True)
    plt.show()


if __name__ == "__main__":
    main()
