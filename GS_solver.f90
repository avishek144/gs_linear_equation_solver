! GS_solver.f90 -- This program solves linear equation using Gauss-Seidel iteration method.
! Copyright (C) 2025 Avishek Gorai <avishekgorai@myyahoo.com>

! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.

! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <https://www.gnu.org/licenses/>.

PROGRAM gauss_seidel_solver
  IMPLICIT NONE

  REAL, PARAMETER :: tolerance = epsilon(1.0) * 1.0E2

  REAL, ALLOCATABLE, DIMENSION(:)    :: x, b, x_new
  REAL, ALLOCATABLE, DIMENSION(:, :) :: coefficient_matrix
  INTEGER number_of_variables, array_allocation_status, equation_number, j, array_deallocation_status, number_of_iterations
  REAL sum_of_first_half, sum_of_second_half, n
  LOGICAL accurate, diagonal_dominance
  INTEGER read_status

  PRINT 10
10 FORMAT (1X, "This program gives approximate solutions to linear equations using Gauss-Seiden method." / &
       1X, "Copyright (C) 2025 by Avishek Gorai <avishekgorai@myyahoo.com>")

  PRINT 20
20 FORMAT ("0", "This program is free software: you can redistribute it and/or modify ", &
       "it under the terms of the GNU General Public License as published by ", &
       "the Free Software Foundation, either version 3 of the License, or ", &
       "(at your option) any later version.")

  PRINT 30
30 FORMAT ("0", "This program is distributed in the hope that it will be useful, ", &
       "but WITHOUT ANY WARRANTY; without even the implied warranty of ", &
       "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the ", &
       "GNU General Public License for more details.")

  PRINT 40
40 FORMAT ("0", "You should have received a copy of the GNU General Public License ", &
       "along with this program.  If not, see <https://www.gnu.org/licenses/>.")


  DO
     PRINT 50
50   FORMAT ("0", "Enter number of variables:-")
     READ (*, *, iostat = read_status) number_of_variables

     IF (read_status == -1) THEN
        PRINT 140
140     FORMAT ("0", "Bye!")
        EXIT
     ELSE IF (read_status /= 0) THEN
        PRINT 130
130     FORMAT ("0", "Invalid input!")
     ELSE
        ALLOCATE (x(number_of_variables), coefficient_matrix(number_of_variables, number_of_variables),&
             b(number_of_variables), x_new(number_of_variables), stat = array_allocation_status)

        IF (array_allocation_status /= 0) THEN
60         FORMAT ("0", "Could not allocate all the arrays! Code:-")
           PRINT *, array_allocation_status
        ELSE
           PRINT 70
70         FORMAT ("0", "Enter the coefficients in column major order:-")
           READ (*, *, iostat = read_status) coefficient_matrix

           IF (read_status == -1) THEN
              EXIT
           ELSE
              diagonal_dominance = .TRUE.
              DO equation_number = 1, number_of_variables
                 sum_of_first_half = 0.0
                 DO j = 1, equation_number - 1
                    sum_of_first_half = sum_of_first_half + coefficient_matrix(equation_number, j)
                 END DO

                 sum_of_second_half = 0.0
                 DO j = equation_number+1, number_of_variables
                    sum_of_second_half = sum_of_second_half + coefficient_matrix(equation_number, j)
                 END DO

                 diagonal_dominance = diagonal_dominance .AND. (abs(coefficient_matrix(equation_number, equation_number)) > &
                      (sum_of_first_half + sum_of_second_half))

                 IF (.NOT. diagonal_dominance)  EXIT
              END DO

              IF (.NOT. diagonal_dominance) THEN
                 PRINT 80,
80               FORMAT ("0", "Diagonal dominance not satisfied by equation number:-")
                 PRINT *, equation_number
              ELSE
                 PRINT 90
90               FORMAT ("0", "Enter the values of constants:-")
                 READ (*, *, iostat = read_status) b

                 IF (read_status == -1) THEN
                    EXIT
                 ELSE
                    DO equation_number = 1, number_of_variables
                       CALL random_number(n)
                       x(equation_number) = n
                    END DO

                    PRINT 100
100                 FORMAT ("0", "Initial values of x:-")
                    PRINT *, x

                    number_of_iterations = 0
                    DO
                       DO equation_number = 1, number_of_variables
                          sum_of_first_half = 0.0
                          DO j = 1, equation_number - 1
                             sum_of_first_half = sum_of_first_half + x_new(j) * coefficient_matrix(equation_number, j)
                          END DO

                          sum_of_second_half = 0.0
                          DO j = equation_number + 1, number_of_variables
                             sum_of_second_half = sum_of_second_half + x(j) * coefficient_matrix(equation_number, j)
                          END DO

                          x_new(equation_number) = (b(equation_number) - sum_of_first_half - sum_of_second_half) / &
                               coefficient_matrix(equation_number, equation_number)
                       END DO

                       accurate = .TRUE.
                       DO equation_number = 1, number_of_variables
                          accurate = accurate .AND. (abs(x_new(equation_number) - x(equation_number)) < tolerance)
                       END DO

                       IF (accurate) THEN
                          EXIT
                       ELSE
                          x = x_new
                          number_of_iterations = number_of_iterations + 1
                       END IF
                    END DO

                    PRINT 110
110                 FORMAT ("0", "Number of iterations required:-")
                    PRINT *, number_of_iterations

                    PRINT 120
120                 FORMAT ("0", "Solution:-")
                    PRINT *, x_new
                 END IF
                 DEALLOCATE (x, coefficient_matrix, b, x_new, stat = array_deallocation_status)
                 IF (array_deallocation_status /= 0) PRINT 150, array_deallocation_status
150              FORMAT ("0", "Could not deallocate arrays! Code: ", I5)
                 EXIT
              END IF
           END IF
        END IF
     END IF
  END DO
END PROGRAM gauss_seidel_solver
