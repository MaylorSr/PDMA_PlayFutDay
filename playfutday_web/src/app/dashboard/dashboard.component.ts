import { Component, OnInit } from "@angular/core";
import Chart from "chart.js";

import { ChartOptions, ChartType, ChartDataSets } from "chart.js";
import { Label } from "ng2-charts";

import { StateUserResponse } from "../interfaces/dashboard/state_user";
import { DashBoardService } from "../_services/dashboard.service";
import { TotalUserAccountCreatedResponse } from "../interfaces/dashboard/total_users_account_created";

@Component({
  selector: "app-dashboard",
  templateUrl: "./dashboard.component.html",
  styleUrls: ["./dashboard.component.css"],
})
export class DashboardComponent implements OnInit {
  stateUserResponse: StateUserResponse[] = [];
  totalUserAccountResponse: TotalUserAccountCreatedResponse[] = [];
  year: number = new Date().getFullYear();
  totalPost: number;
  // selected = 'none';
  selectedMonth: number;
  months: { value: number; name: string }[];

  constructor(private dashboardService: DashBoardService) {}

  public barChartOptions: ChartOptions = {
    responsive: true,
  };
  public barChartLabels: Label[] = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  public barChartType: ChartType = "bar";
  public barChartLegend = true;
  public barChartData: ChartDataSets[] = [];

  ngOnInit(): void {
    {
      this.dashboardService.getAllUserStateInApp().subscribe((data) => {
        this.stateUserResponse = data;
        // Lógica de asignación de valores para el gráfico
        const inactiveUser = this.stateUserResponse.find(
          (data) => data.state === "inactive"
        );
        const activeUser = this.stateUserResponse.find(
          (data) => data.state === "active"
        );

        const inactiveValue = inactiveUser ? inactiveUser.value : 0;
        const activeValue = activeUser ? activeUser.value : 0;

        // Actualizar los valores del gráfico
        const ctx = document.getElementById("myChart") as HTMLCanvasElement;
        const myChart = new Chart(ctx, {
          type: "doughnut",
          data: {
            labels: ["Inactive", "Active"],
            datasets: [
              {
                label: "# of users state",
                data: [inactiveValue, activeValue],
                backgroundColor: [
                  "rgb(165, 42, 42, 0.6)",
                  "rgba(0, 128, 0, 0.6)",
                ],
                borderColor: ["rgba(165, 42, 42, 1)", "rgba(0, 128, 0, 1)"],
                borderWidth: 1,
              },
            ],
          },
          options: {
            responsive: true,
            plugins: {
              title: {
                display: true,
                text: "State of users",
              },
            },
          },
        });
      });
    }
    this.fetchTotalUsersAccountByYear(this.year);

    this.selectedMonth = 0; // Valor predeterminado para "None" esto muestra todos los post de todos los meses.
    this.months = [];

    for (let i = 1; i <= 12; i++) {
      //SACAMOS LOS NOMBRES DE LOS MESES EN INGLÉS
      const monthName = new Date(0, i - 1).toLocaleString("en", {
        month: "long",
      });
      this.months.push({ value: i, name: monthName });
    }

    this.showTotalPostByMonth(this.selectedMonth);
  }

  fetchTotalUsersAccountByYear(year: number) {
    this.dashboardService.getTotalAccountsCreatedByYear(year).subscribe({
      next: (dateListAccount) => {
        this.totalUserAccountResponse = dateListAccount;
        const monthlyData = Array(12).fill(0);

        // Asignar los valores recibidos de la API en los índices correspondientes
        this.totalUserAccountResponse.forEach((data) => {
          const monthIndex = data.month - 1; // Restar 1 para ajustar al índice del array
          monthlyData[monthIndex] = data.totalUsersCreated;
        });

        const backgroundColors: string[] = [];
        const borderColors: string[] = [];

        for (let i = 0; i < 12; i++) {
          const colorIndex = i % 2 === 0 ? 0 : 1; // Alternar entre índices 0 y 1 para los colores
          const backgroundColor =
            colorIndex === 0
              ? "rgba(54, 162, 235, 0.2)"
              : "rgba(75, 192, 192, 0.2)";
          const borderColor =
            colorIndex === 0 ? "rgb(54, 162, 235)" : "rgb(75, 192, 192)";

          backgroundColors.push(backgroundColor);
          borderColors.push(borderColor);
        }

        this.totalUserAccountResponse.forEach((data) => {
          const monthIndex = data.month - 1;
          monthlyData[monthIndex] = data.totalUsersCreated;
        });

        // Asignar los datos transformados al gráfico de barras
        this.barChartData = [
          {
            data: monthlyData,
            label: "Created users account",
            backgroundColor: backgroundColors,
            borderColor: borderColors,
            hoverBackgroundColor: "rgba(0, 0, 0, 0.2)",
            borderWidth: 1,
          },
        ];
      },
      error: (err) => {
        this.totalUserAccountResponse = [];
        this.barChartData = [
          {
            data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            label: "Created users account",
          },
        ];
      },
    });
  }

  onMonthChange() {
    this.showTotalPostByMonth(this.selectedMonth);
  }

  changeYear(yearChange: number) {
    const newYear = this.year + yearChange;
    if (newYear <= new Date().getFullYear()) {
      this.year = newYear;
      this.fetchTotalUsersAccountByYear(this.year);
    }
  }

  showTotalPostByMonth(month: number) {
    this.dashboardService.getTotalPostByNumberMonth(month).subscribe((res) => {
      this.totalPost = res;
    });
  }
}
