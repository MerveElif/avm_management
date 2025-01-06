import React, { useEffect, useState } from "react";
import { gql, useQuery } from "@apollo/client";
import { PageContainer } from "@keystone-6/core/admin-ui/components";
import { Heading } from "@keystone-ui/core";
import { Bar } from "react-chartjs-2";
import {
  CategoryScale,
  Chart as ChartJS,
  BarElement,
  LinearScale,
} from "chart.js";

ChartJS.register(CategoryScale, LinearScale, BarElement);

const GET_MONTHLY_PAYMENTS = gql`
  query GetMonthlyPayments {
    payments {
      amount
      paymentDate
    }
  }
`;

interface Payment {
  amount: string;
  paymentDate: string;
}

interface PaymentQueryResult {
  payments: Payment[];
}

export default function CustomDashboard(): JSX.Element {
  const { data, loading, error } =
    useQuery<PaymentQueryResult>(GET_MONTHLY_PAYMENTS);
  const [chartData, setChartData] = useState<{
    labels: string[];
    datasets: { label: string; data: number[]; backgroundColor: string }[];
  }>({
    labels: [],
    datasets: [],
  });

  useEffect(() => {
    if (data) {
      const monthlyData = getMonthlyPaymentData(data.payments);
      setChartData({
        labels: Object.keys(monthlyData),
        datasets: [
          {
            label: "Toplanan Kiralar",
            data: Object.values(monthlyData),
            backgroundColor: "rgba(75, 192, 192, 0.6)",
          },
        ],
      });
    }
  }, [data]);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <PageContainer header={<Heading type="h3">Aylık Toplanan Kiralar</Heading>}>
      <div style={{ width: "100%", height: "400px" }}>
        <Bar
          data={chartData}
          options={{
            responsive: true,
            plugins: {
              legend: {
                position: "top",
              },
            },
          }}
        />
      </div>
    </PageContainer>
  );
}

function getMonthlyPaymentData(payments: Payment[]): Record<string, number> {
  const monthlyTotals: Record<string, number> = {};

  payments.forEach((payment) => {
    const date = new Date(payment.paymentDate);
    const month = `${date.getFullYear()}-${(date.getMonth() + 1)
      .toString()
      .padStart(2, "0")}`;

    if (!monthlyTotals[month]) {
      monthlyTotals[month] = 0;
    }
    monthlyTotals[month] += parseFloat(payment.amount);
  });

  return monthlyTotals;
}
