namespace FootballClubsApp
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();
        }

        private ClubsRepository repo = new ClubsRepository();

        private void LoadClubs()
        {
            try
            {
                dgvClubs.DataSource = repo.GetAll();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Грешка: " + ex.Message);
            }
        }

        private void btnLoad_Click(object sender, EventArgs e)
        {
            LoadClubs();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtName.Text))
            {
                MessageBox.Show("Името е задължително!");
                return;
            }

            try
            {
                Club c = new Club { Name = txtName.Text, City = txtCity.Text };
                repo.Add(c);
                MessageBox.Show("Успешно добавен!");
                LoadClubs();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Грешка: " + ex.Message);
            }
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            if (dgvClubs.CurrentRow == null)
            {
                MessageBox.Show("Изберете ред!");
                return;
            }

            try
            {
                Club c = new Club
                {
                    ClubId = Convert.ToInt32(dgvClubs.CurrentRow.Cells["ClubId"].Value),
                    Name = txtName.Text,
                    City = txtCity.Text
                };

                repo.Update(c);
                MessageBox.Show("Успешно редактиран!");
                LoadClubs();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Грешка: " + ex.Message);
            }
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            if (dgvClubs.CurrentRow == null)
            {
                MessageBox.Show("Изберете ред!");
                return;
            }

            var confirm = MessageBox.Show("Сигурни ли сте?", "Потвърждение", MessageBoxButtons.YesNo);
            if (confirm != DialogResult.Yes) return;

            try
            {
                int id = Convert.ToInt32(dgvClubs.CurrentRow.Cells["ClubId"].Value);
                repo.Delete(id);
                MessageBox.Show("Изтрит!");
                LoadClubs();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Грешка: " + ex.Message);
            }
        }

        private void dgvClubs_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                txtName.Text = dgvClubs.Rows[e.RowIndex].Cells["Name"].Value.ToString();
                txtCity.Text = dgvClubs.Rows[e.RowIndex].Cells["City"].Value.ToString();
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            try
            {
                using (var conn = Db.GetConnection())
                {
                    conn.Open();
                    MessageBox.Show("Връзката работи!");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Грешка: " + ex.Message);
            }
        }

        private void dgvClubs_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
